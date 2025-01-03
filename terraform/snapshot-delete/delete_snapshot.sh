#!/bin/bash

# Define the cutoff date, filter tag key, and filter tag value
cutoff_date="2025-01-01T00:00:00Z"  # Example cutoff date
filter_tag_key="testing"       # Replace with your tag key
filter_tag_value="Value"   # Replace with your tag value

echo "Fetching snapshots older than ${cutoff_date}..."
snapshot_ids=$(aws ec2 describe-snapshots \
    --filters "Name=tag:${filter_tag_key},Values=${filter_tag_value}" \
    --query "Snapshots[?StartTime<'${cutoff_date}'].SnapshotId" \
    --output text)

echo "Found snapshots: $snapshot_ids"

if [ -z "$snapshot_ids" ]; then
    echo "No snapshots found to delete."
    exit 0
fi

for snapshot_id in $snapshot_ids; do
    echo "Attempting to delete snapshot: $snapshot_id"
    aws ec2 delete-snapshot --snapshot-id $snapshot_id
    if [ $? -eq 0 ]; then
        echo "Successfully deleted snapshot: $snapshot_id"
    else
        echo "Failed to delete snapshot: $snapshot_id"
    fi
done
