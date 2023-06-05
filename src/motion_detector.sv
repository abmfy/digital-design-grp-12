module motion_detector (
    input signed [15:0] acceleration,
    input signed [15:0] direction,
    output logic jumping,
    output logic ducking
);
  // https://wit-motion.yuque.com/wumwnr/ltst03/vl3tpy
  always_comb begin
    ducking = direction < 8192;  // < 45°
    jumping = !ducking && acceleration >= -512;  // >= -0.25g
  end
endmodule
