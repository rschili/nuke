#!/usr/bin/env bash

NOINIT=0
BUILD_ARGUMENTS=()
for i in "$@"; do
    case $(echo $1 | awk '{print tolower($0)}') in
        -noinit) NOINIT=1;;
        *) BUILD_ARGUMENTS+=("$1") ;;
    esac
    shift
done

set -eo pipefail
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

###########################################################################
# CONFIGURATION
###########################################################################

DOTNET_CHANNEL="2.0"
BUILD_PROJECT_FILE="$SCRIPT_DIR/_BUILD_DIRECTORY_NAME_/_BUILD_PROJECT_NAME_.csproj"

TEMP_DIRECTORY="$SCRIPT_DIR/.tmp"

DOTNET_SCRIPT_URL="https://raw.githubusercontent.com/dotnet/cli/master/scripts/obtain/dotnet-install.sh"
DOTNET_DIRECTORY="$TEMP_DIRECTORY/dotnet"
DOTNET_FILE="$DOTNET_DIRECTORY/dotnet"
export DOTNET_EXE="$DOTNET_FILE"

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
export NUGET_XMLDOC_MODE="skip"

###########################################################################
# PREPARE BUILD
###########################################################################

if ! ((NOINIT)); then
  mkdir -p "$DOTNET_DIRECTORY"

  DOTNET_SCRIPT_FILE="$TEMP_DIRECTORY/dotnet-install.sh"
  if [ ! -f "$DOTNET_SCRIPT_FILE" ]; then curl -Lsfo "$DOTNET_SCRIPT_FILE" $DOTNET_SCRIPT_URL; chmod +x "$DOTNET_SCRIPT_FILE"; fi
  "$DOTNET_SCRIPT_FILE" --install-dir "$DOTNET_DIRECTORY" --channel 2.0 --no-path

  "$DOTNET_FILE" restore "$BUILD_PROJECT_FILE"
fi

"$DOTNET_FILE" build "$BUILD_PROJECT_FILE" --no-restore

###########################################################################
# EXECUTE BUILD
###########################################################################

"$DOTNET_FILE" run --project "$BUILD_PROJECT_FILE" --no-build -- ${BUILD_ARGUMENTS[@]}
