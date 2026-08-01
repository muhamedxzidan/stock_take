---
type: "debugging"
date: "2026-08-01T22:20:34.007410+00:00"
question: "Why does printing the complete stock balance corrupt on XP-P802A while short movement receipts print correctly?"
contributor: "graphify"
outcome: "useful"
source_nodes: ["ThermalReceiptImageSlicer", "BluetoothPrinterRepository", "printReceiptPng"]
---

# Q: Why does printing the complete stock balance corrupt on XP-P802A while short movement receipts print correctly?

## Answer

The stock balance was rendered as one very tall PNG and sent as one ESC/POS raster payload. The Android plugin writes that whole payload in a single socket write, exceeding the XP-P802A input buffer on long receipts. The fix keeps one logical receipt but crops it into safe vertical PNG slices, prints them sequentially with no feeds between slices, feeds only after the last slice, maps overall progress across slices, and stops on failure without replaying already printed slices.

## Outcome

- Signal: useful

## Source Nodes

- ThermalReceiptImageSlicer
- BluetoothPrinterRepository
- printReceiptPng