class FlatOut
  def initialize(rec_length)
    @flat_out = " " * rec_length
    @flat_length = rec_length
    @@base ||= 1
  end

  def reset(rec_length=@flat_length)
    @flat_out = " " * rec_length
    @flat_length = rec_length
  end

  def to_s
    @flat_out
  end

  def self.base(base)
    @@base = base
  end

  def self.phone_squeeze(fld)
    fld.tr("-)( " , "")
  end

  def self.digits_only(fld)
    fld.gsub(/[^\d]/,"")
  end

  def put len, pos, fld
    case fld
    when String
      put_alpha len, pos, fld
    when Integer
      put_integer len, pos, fld
    when Float
      if len.to_s.match(/\./)
        put_float len, pos, fld
      else
        put_integer len, pos, fld
      end
    end
  end

  private

  def put_fld len, pos, fld
    start_pos = pos - @@base ; end_pos = start_pos + len
    @flat_out[start_pos...end_pos] = fld
  end

  def put_alpha len, pos, fld
    space_fill = " " * len
    val = (fld.to_s + space_fill)[0...len]
    put_fld len, pos, val
  end

  def put_integer len, pos, fld
    data_content = fld.to_i.to_s
    data_len = data_content.length
    zero_fill = "0" * len
    val = (zero_fill + data_content)[-len,len]
    put_fld len, pos, val
  end

  def put_float int_dot_dec, pos, fld
    int = int_dot_dec.to_s.split(".")[0].to_i.abs
    put_integer int, pos, fld

    pos = pos + int
    if int_dot_dec > 0
      put_fld 1, pos, '.'
      pos = pos + 1
    end

    dec = int_dot_dec.to_s.split(".")[1].to_i
    val =  sprintf("%0.#{dec}f", fld)[-dec,dec]
    put_fld dec, pos, val
  end
end
