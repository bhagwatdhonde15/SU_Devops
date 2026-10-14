#!/usr/bin/env bash
# ==============================================================================
# Enterprise Smart Library Management Platform - Automated S3 Backup Script
# Unit 4: Infrastructure Automation
# Student: Bhagwat Dhonde (PRN: 2125UMLM1015)
# ==============================================================================

set -euo pipefail

DB_SOURCE="${1:-/opt/library/data/library.db}"
AWS_REGION="${AWS_REGION:-us-east-1}"

# Auto-detect bucket if not set via environment
if [ -z "${S3_BUCKET_NAME:-}" ]; then
  ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text 2>/dev/null || echo "")
  if [ -n "$ACCOUNT_ID" ]; then
    S3_BUCKET_NAME="library-backup-${ACCOUNT_ID}-${AWS_REGION}"
  else
    echo "ERROR: Could not detect AWS Account ID. Set S3_BUCKET_NAME environment variable." >&2
    exit 1
  fi
fi

S3_DESTINATION="s3://${S3_BUCKET_NAME}/backups/library.db"

echo "=========================================================="
echo " Starting Smart Library SQLite Database S3 Backup"
echo " Time:        $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo " Source:      ${DB_SOURCE}"
echo " Destination: ${S3_DESTINATION}"
echo " Region:      ${AWS_REGION}"
echo "=========================================================="

if [ ! -f "${DB_SOURCE}" ]; then
  echo "WARNING: Database file not found at ${DB_SOURCE}. Checking Docker container..."
  # If running in container, copy out
  if command -v docker >/dev/null 2>&1 && docker ps | grep -q smart-library-app; then
    mkdir -p /tmp/backup_staging
    docker cp smart-library-app:/opt/library/data/library.db /tmp/backup_staging/library.db
    DB_SOURCE="/tmp/backup_staging/library.db"
  else
    echo "ERROR: Unable to locate source library.db" >&2
    exit 1
  fi
fi

# Upload database to S3 with standard SSE encryption
aws s3 cp "${DB_SOURCE}" "${S3_DESTINATION}" \
  --sse AES256 \
  --region "${AWS_REGION}"

echo "=========================================================="
echo " Backup successfully uploaded to S3!"
echo " Verification:"
aws s3 ls "${S3_DESTINATION}" --region "${AWS_REGION}"
echo "=========================================================="
