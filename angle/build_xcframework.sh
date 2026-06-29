#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/build_xcframework.sh [options]

Build release ANGLE iOS XCFrameworks for device arm64 and Apple Silicon simulator arm64.
Simulator x64 is intentionally not built or packaged.

Options:
  --skip-build          Only package existing build outputs.
  --gn-arg <arg>        Forward one raw GN arg to scripts/build_ios.sh.
                        May be specified multiple times.
  -h, --help            Show this help.

Outputs:
  dist/ios-xcframework-release/libEGL.xcframework
  dist/ios-xcframework-release/libGLESv2.xcframework

Examples:
  scripts/build_xcframework.sh
  scripts/build_xcframework.sh --skip-build
  scripts/build_xcframework.sh --gn-arg 'symbol_level=0'
EOF
}

config="release"
out_dir="dist/ios-xcframework-release"
skip_build="false"
extra_gn_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-build)
      skip_build="true"
      shift
      ;;
    --gn-arg)
      if [[ $# -lt 2 ]]; then
        echo "error: --gn-arg requires a value" >&2
        exit 1
      fi
      extra_gn_args+=(--gn-arg "$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
cd "${repo_root}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "error: XCFramework packaging requires macOS with Xcode installed." >&2
  exit 1
fi

if ! xcodebuild -version >/dev/null 2>&1; then
  echo "error: Xcode command line tools are not available." >&2
  exit 1
fi

device_out="out/ios-device-arm64-${config}"
simulator_out="out/ios-simulator-arm64-${config}"
build_mode="--${config}"

if [[ "${skip_build}" != "true" ]]; then
  device_build_args=(--device "${build_mode}" --out "${device_out}")
  simulator_build_args=(--simulator-arm64 "${build_mode}" --out "${simulator_out}")
  if [[ ${#extra_gn_args[@]:-0} -gt 0 ]]; then
    device_build_args+=("${extra_gn_args[@]}")
    simulator_build_args+=("${extra_gn_args[@]}")
  fi

  "${script_dir}/build_ios.sh" "${device_build_args[@]}"
  "${script_dir}/build_ios.sh" "${simulator_build_args[@]}"
fi

frameworks=(libEGL libGLESv2)
public_header_dirs=(EGL GLES GLES2 GLES3 KHR)
public_header_files=(export.h angle_gl.h)
strip_tool="$(xcrun -f strip)"

install_public_headers() {
  local framework_dir="$1"
  local headers_dir="${framework_dir}/Headers"

  rm -rf "${headers_dir}"
  mkdir -p "${headers_dir}"

  for header_dir in "${public_header_dirs[@]}"; do
    mkdir -p "${headers_dir}/${header_dir}"
    find "include/${header_dir}" -maxdepth 1 -type f -name '*.h' -exec cp '{}' "${headers_dir}/${header_dir}/" \;
  done

  for header_file in "${public_header_files[@]}"; do
    cp "include/${header_file}" "${headers_dir}/"
  done
}

strip_framework_binary() {
  local framework_dir="$1"
  local framework_name
  local binary_path

  framework_name="$(basename "${framework_dir}" .framework)"
  binary_path="${framework_dir}/${framework_name}"

  if [[ ! -f "${binary_path}" ]]; then
    echo "error: missing framework binary: ${binary_path}" >&2
    exit 1
  fi

  "${strip_tool}" -x -S "${binary_path}"
}

for framework in "${frameworks[@]}"; do
  device_framework="${device_out}/${framework}.framework"
  simulator_framework="${simulator_out}/${framework}.framework"

  if [[ ! -d "${device_framework}" ]]; then
    echo "error: missing device framework: ${device_framework}" >&2
    exit 1
  fi
  if [[ ! -d "${simulator_framework}" ]]; then
    echo "error: missing simulator framework: ${simulator_framework}" >&2
    exit 1
  fi

  install_public_headers "${device_framework}"
  install_public_headers "${simulator_framework}"
  strip_framework_binary "${device_framework}"
  strip_framework_binary "${simulator_framework}"
done

rm -rf "${out_dir}"
mkdir -p "${out_dir}"

for framework in "${frameworks[@]}"; do
  echo "==> create ${out_dir}/${framework}.xcframework"
  xcodebuild -create-xcframework \
    -framework "${device_out}/${framework}.framework" \
    -framework "${simulator_out}/${framework}.framework" \
    -output "${out_dir}/${framework}.xcframework"
done

echo "==> done: ${out_dir}"
