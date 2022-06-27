def caesar_cipher(str, shift_factor)
  str = str.split("")
  ordinal_array = str.map { |letter| letter.ord }
  cipher = ordinal_array.map do |letter|
    if((letter).between?(97, 122))
      letter = letter+shift_factor>122?letter+shift_factor-26:letter+shift_factor
    elsif((letter).between?(65, 90))
      letter = letter+shift_factor>90?letter+shift_factor-26:letter+shift_factor
    end  
    letter  
  end
  cipher.map { |letter| letter.chr}.join
end

p caesar_cipher("What a string!", 5)



