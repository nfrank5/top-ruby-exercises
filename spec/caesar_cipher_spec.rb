require "./lib/caesar_cipher"

describe CaesarCipher do

  describe '#caesar_cipher' do
    it 'returns the cipher of single letters' do
      cesar = CaesarCipher.new
      expect(cesar.caesar_cipher('h', 5)).to eq('m')
    end

    it 'returns the cipher of entire words' do
      cesar = CaesarCipher.new
      expect(cesar.caesar_cipher('hello', 5)).to eq('mjqqt')
    end

    it 'returns cipher with upercase' do
      cesar = CaesarCipher.new
      expect(cesar.caesar_cipher('Hello', 5)).to eq('Mjqqt')
    end

    it 'returns cipher wirh alphabet last letters' do
      cesar = CaesarCipher.new
      expect(cesar.caesar_cipher('Zoom zoo', 5)).to eq('Ettr ett')
    end

    it 'returns cipher with alphabet first letters' do
      cesar = CaesarCipher.new
      expect(cesar.caesar_cipher('What a string!', 5)).to eq('Bmfy f xywnsl!')
    end
  end
 
end