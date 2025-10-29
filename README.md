# Image Rotation and Mirroring
Requirements: Design a hardware block to rotate an image by 90° (clockwise/counterclockwise) and to mirror it horizontally or vertically. The design fetches pixels from memory,
computes new coordinates, and stores the transformed image back.
• Input: Grayscale image stored in memory.
• Output: Rotated (90° CW/CCW) or mirrored image saved back to memory.
• Algorithm: Perform coordinate remapping for each pixel (x,y → x’,y’).
