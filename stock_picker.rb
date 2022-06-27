def stock_picker(prices)
  best_profit = prices[1] - prices[0]
  pair_of_days = []
  prices.each_with_index do |price, index| 
    futures = prices.slice(index+1, prices.length)
    futures.each_with_index do | future_price, future_index |
      if((future_price - price) > best_profit)
        best_profit = future_price - price
        pair_of_days[0] = index
        pair_of_days[1] = future_index + index + 1
      end
    end
  end
  pair_of_days
end

p stock_picker([17,3,6,9,15,8,6,1,10])