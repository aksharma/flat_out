class FlatOut

  #attr_accessor :flat_out, :flat_length, :base, :format, :template

  def initialize(rec_length, options={})
    self.reset(rec_length, options)
  end

  def reset(rec_length=@flat_length, options={})
    @base = options[:base] ||= @base ||= 1
    @format = options[:format] ||= @format ||= :len_pos_fld
    @template = options[:template] ||= @template ||= []
    @flat_length = rec_length
    @flat_out = " " * rec_length
    return @flat_out
  end

  def to_s
    (@flat_out + (' ' * @flat_length))[0...@flat_length]
  end

  def self.phone_squeeze(fld)
    fld.tr("-)( " , "")
  end

  def self.digits_only(fld)
    fld.gsub(/[^\d]/,"")
  end

  def put p1, p2=1, p3=''
    if @template.size > 0 && p1.class == Array
      fld = p1
    else
      case @format
      when :len_pos_fld then (len = p1; pos = p2; fld = p3)
      when :len_fld_pos then (len = p1; fld = p2; pos = p3)
      when :pos_len_fld then (pos = p1; len = p2; fld = p3)
      when :pos_fld_len then (pos = p1; fld = p2; len = p3)
      when :fld_pos_len then (fld = p1; pos = p2; len = p3)
      when :fld_len_pos then (fld = p1; len = p2; pos = p3)
      when :fld_len     then (fld = p1)
      when :len_fld     then (fld = p1)
      else                   (len = p1; pos = p2; fld = p3)
      end
    end

    case fld
    when Array
      if @template.size > 0 and @template[0].class == Array    # :template => [[5,1],[5,6],[4.2,11]]
        fld.each_with_index do |field,idx|
          len = @template[idx][0]
          pos = @template[idx][1]
          put len, pos, field
        end
      elsif @template.size > 0                                 # :template => [5,5,4.2,3]
        pos = @base
        fld.each_with_index do |field, idx|
          len = @template[idx]
          put len, pos, field
          pos = pos + real_len(len)
        end
      elsif @format == :fld_len                                # val = ['ABCD', 5, 10, 5]
        @format = :len_pos_fld
        pos = @base
        fld.each_slice(2) do |arr|
          field = arr[0]
          len = arr[1]
          put len, pos, field
          pos = pos + real_len(len)
        end
      elsif @format == :len_fld                                # val = [5, 'ABCD', 4.2, 10.23]
        @format = :len_pos_fld
        pos = @base
        fld.each_slice(2) do |arr|
          len = arr[0]
          field = arr[1]
          put len, pos, field
          pos = pos + real_len(len)
        end
      end
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
    return self.to_s
  end

  private

  def put_fld len, pos, fld
    start_pos = pos - @base ; end_pos = start_pos + len
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

  def real_len(len)
    return len if len.integer?

    int = len.to_s.split(".")[0].to_i.abs
    dec = len.to_s.split(".")[1].to_i
    if len > 0
      return int + 1 + dec
    else
      return int + dec
    end
  end
end
