#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/build_ios.sh [options] [ninja targets...]

Build ANGLE for iOS with GN + Ninja.

Options:
  --device              Build for iPhone/iPad device. Default is simulator.
  --simulator           Build for iOS simulator.
  --simulator-arm64     Build for Apple Silicon iOS simulator.
  --simulator-x64       Build for Intel iOS simulator.
  --release             Release build. Default is debug.
  --debug               Debug build.
  --cpu <cpu>           Target CPU. Defaults to arm64.
                        Use x64 for Intel Mac simulator.
  --out <dir>           Output directory. Defaults to out/ios-<env>-<cpu>-<config>.
  --codesign            Enable iOS code signing for device builds.
  --gn-arg <arg>        Append one raw GN arg, e.g. --gn-arg 'symbol_level=1'.
                        Later GN args override the script defaults.
  -h, --help            Show this help.

Default targets:
  libEGL libGLESv2

Examples:
  scripts/build_ios.sh
  scripts/build_ios.sh --release
  scripts/build_ios.sh --device --release --codesign libEGL libGLESv2
  scripts/build_ios.sh --simulator-arm64 --release
  scripts/build_ios.sh --simulator --cpu x64 angle_end2end_tests
EOF
}

env="simulator"
config="debug"
cpu="arm64"
out_dir=""
codesign="false"
extra_gn_args=()
targets=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --device)
      env="device"
      shift
      ;;
    --simulator)
      env="simulator"
      shift
      ;;
    --simulator-arm64)
      env="simulator"
      cpu="arm64"
      shift
      ;;
    --simulator-x64)
      env="simulator"
      cpu="x64"
      shift
      ;;
    --release)
      config="release"
      shift
      ;;
    --debug)
      config="debug"
      shift
      ;;
    --cpu)
      if [[ $# -lt 2 ]]; then
        echo "error: --cpu requires a value" >&2
        exit 1
      fi
      cpu="$2"
      shift 2
      ;;
    --out)
      if [[ $# -lt 2 ]]; then
        echo "error: --out requires a value" >&2
        exit 1
      fi
      out_dir="$2"
      shift 2
      ;;
    --codesign)
      codesign="true"
      shift
      ;;
    --gn-arg)
      if [[ $# -lt 2 ]]; then
        echo "error: --gn-arg requires a value" >&2
        exit 1
      fi
      extra_gn_args+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      targets+=("$@")
      break
      ;;
    -*)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      targets+=("$1")
      shift
      ;;
  esac
done

if [[ ${#targets[@]:-0} -eq 0 ]]; then
  targets=(libEGL libGLESv2)
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
cd "${repo_root}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "error: iOS builds require macOS with Xcode installed." >&2
  exit 1
fi

if ! command -v gn >/dev/null 2>&1; then
  echo "error: gn not found in PATH. Add depot_tools to PATH." >&2
  exit 1
fi

if ! command -v ninja >/dev/null 2>&1; then
  echo "error: ninja not found in PATH. Add depot_tools to PATH." >&2
  exit 1
fi

if ! xcodebuild -version >/dev/null 2>&1; then
  echo "error: Xcode command line tools are not available." >&2
  exit 1
fi

if [[ -z "${out_dir}" ]]; then
  out_dir="out/ios-${env}-${cpu}-${config}"
fi

case "${cpu}" in
  arm64|x64)
    ;;
  *)
    echo "error: unsupported iOS CPU '${cpu}'. Use arm64 or x64." >&2
    exit 1
    ;;
esac

if [[ "${env}" == "device" && "${cpu}" != "arm64" ]]; then
  echo "error: iOS device builds only support --cpu arm64." >&2
  exit 1
fi

mkdir -p "${out_dir}/.gocache" "${out_dir}/.gopath/pkg/mod"
export GOCACHE="${repo_root}/${out_dir}/.gocache"
export GOPATH="${repo_root}/${out_dir}/.gopath"
export GOMODCACHE="${GOPATH}/pkg/mod"

is_debug="true"
if [[ "${config}" == "release" ]]; then
  is_debug="false"
fi

gn_args=(
  'target_os="ios"'
  "target_environment=\"${env}\""
  "target_cpu=\"${cpu}\""
  'ios_deployment_target="14.0"'
  "is_debug=${is_debug}"
  "is_component_build=false"
  "angle_enable_wgpu=false"
  "angle_enable_null=false"
  "angle_enable_vulkan=false"
)

if [[ "${env}" == "device" ]]; then
  gn_args+=("ios_enable_code_signing=${codesign}")
fi

if [[ "${config}" == "release" ]]; then
  gn_args+=(
    "symbol_level=0"
    "enable_stripping=true"
    "strip_debug_info=true"
    "angle_enable_commit_id=false"
  )
fi

if [[ ${#extra_gn_args[@]:-0} -gt 0 ]]; then
  gn_args+=("${extra_gn_args[@]}")
fi

gn_args_text="$(printf '%s\n' "${gn_args[@]}")"

echo "==> gn gen ${out_dir}"
printf '%s\n' "${gn_args_text}"
gn gen "${out_dir}" --args="${gn_args_text}"

echo "==> ninja -C ${out_dir} ${targets[*]}"
ninja -C "${out_dir}" "${targets[@]}"
