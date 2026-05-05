#!/usr/bin/env sh
set -eu

REPO_URL="https://github.com/Kroco75/boiler-temperature.git"
ESPHOME_DIR="/root/config/esphome"
GIT_DIR="${ESPHOME_DIR}/git"
REPO_DIR="${GIT_DIR}/boiler-temperature"
SOURCE_ESPHOME_DIR="${REPO_DIR}/esphome"
SOURCE_DEVICE_DIR="${SOURCE_ESPHOME_DIR}/boiler-temperature"
TARGET_DEVICE_DIR="${ESPHOME_DIR}/boiler-temperature"
TARGET_OLD_DIR="${ESPHOME_DIR}/boiler-temperature_old"

echo "== Boiler temperature ESPHome update =="

mkdir -p "${GIT_DIR}"
cd "${GIT_DIR}"

if [ -z "${REPO_DIR}" ] || [ "${REPO_DIR}" = "/" ]; then
  echo "ERROR: Unsafe REPO_DIR: ${REPO_DIR}"
  exit 1
fi

if [ -e "${REPO_DIR}" ]; then
  echo "Removing previous clone: ${REPO_DIR}"
  rm -rf "${REPO_DIR}"
fi

echo "Cloning repository..."
git clone "${REPO_URL}" "${REPO_DIR}"

if [ ! -d "${SOURCE_ESPHOME_DIR}" ]; then
  echo "ERROR: Source ESPHome directory not found: ${SOURCE_ESPHOME_DIR}"
  exit 1
fi

if [ ! -f "${SOURCE_ESPHOME_DIR}/boiler-temperature.yaml" ]; then
  echo "ERROR: Source YAML not found: ${SOURCE_ESPHOME_DIR}/boiler-temperature.yaml"
  exit 1
fi

echo "Removing everything in cloned repo except esphome/..."
find "${REPO_DIR}" -mindepth 1 -maxdepth 1 ! -name "esphome" -exec rm -rf {} +

echo "Copying main YAML to ${ESPHOME_DIR}..."
cp -f "${SOURCE_ESPHOME_DIR}/boiler-temperature.yaml" "${ESPHOME_DIR}/boiler-temperature.yaml"

if [ -d "${TARGET_OLD_DIR}" ]; then
  echo "Removing previous backup: ${TARGET_OLD_DIR}"
  rm -rf "${TARGET_OLD_DIR}"
fi

if [ -d "${TARGET_DEVICE_DIR}" ]; then
  echo "Backing up existing ${TARGET_DEVICE_DIR} to ${TARGET_OLD_DIR}"
  mv "${TARGET_DEVICE_DIR}" "${TARGET_OLD_DIR}"
fi

echo "Creating target device directory: ${TARGET_DEVICE_DIR}"
mkdir -p "${TARGET_DEVICE_DIR}"

for dir in common packages images; do
  if [ ! -d "${SOURCE_DEVICE_DIR}/${dir}" ]; then
    echo "ERROR: Required source directory not found: ${SOURCE_DEVICE_DIR}/${dir}"
    exit 1
  fi

  echo "Copying ${dir}/..."
  cp -R "${SOURCE_DEVICE_DIR}/${dir}" "${TARGET_DEVICE_DIR}/${dir}"
done

echo "Update completed successfully."
echo "Main YAML: ${ESPHOME_DIR}/boiler-temperature.yaml"
echo "Packages:  ${TARGET_DEVICE_DIR}/packages"
echo "Common:    ${TARGET_DEVICE_DIR}/common"
echo "Images:    ${TARGET_DEVICE_DIR}/images"

