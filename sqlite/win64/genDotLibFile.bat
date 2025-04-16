@echo off
REM build.bat

REM 设置环境变量
call "D:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"


REM 生成导入库
lib /def:sqlite3.def /out:sqlite3.lib /machine:x64