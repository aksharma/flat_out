class FlatOut
  def initialize(rec_length)
    @flat_out = " " * rec_length
    @flat_length = rec_length
  end

  def reset(rec_length=@flat_length)
    @flat_out = " " * rec_length
    @flat_length = rec_length
  end

  def put_alpha len, pos, fld
    start_pos = pos - 1 ; end_pos = start_pos + len
    space_fill = " " * len
    val = (fld.to_s + space_fill)[0...len]
    @flat_out[start_pos...end_pos] = val
  end

  def put_integer len, pos, fld
    data_content = fld.to_s
    data_len = data_content.length
    zero_fill = "0" * len
    val = (zero_fill + data_content)[-len,len]
    put_alpha len, pos, val
  end

  def put_integer_part len, pos, fld
    val =  fld.to_i
    put_integer len, pos, val
  end

  def put_digits_only len, pos, fld
    val = fld.gsub(/[^\d]/,"")
    put_alpha len, pos, val
  end

  def put_decimal_with_point int_dot_dec, pos, fld
    precision = int_dot_dec.to_s.split(".")[1].to_i
    len = int_dot_dec.to_s.split(".")[0].to_i + precision + 1
    val =  sprintf("%#{len}.#{precision}f", fld)[-len,len]
    val = val.tr(" ","0")
    put_alpha len, pos, val
  end

  def put_decimal_no_point int_dot_dec, pos, fld
    precision = int_dot_dec.to_s.split(".")[1].to_i
    len = int_dot_dec.to_s.split(".")[0].to_i + precision + 1
    val =  sprintf("%#{len}.#{precision}f", fld)[-len,len]
    val = val.tr(" ","0")
    val = val.sub(".","")
    put_alpha len, pos, val
  end

  def to_s
    @flat_out
  end
end
