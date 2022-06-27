dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
def substrings(word, dic)
  word_array = word.downcase.split(" ")
  dic.reduce(Hash.new(0)) do |subs, sub|
    word_array.each do |w|
      if(w.include?(sub))
        subs[sub] +=1
      end
    end
    subs
  end
end

p substrings("below", dictionary)
p substrings("Howdy partner, sit down! How's it going?", dictionary)
