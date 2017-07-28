require 'pry'
require 'csv'
require_relative 'merchant'

class MerchantRepository

  attr_reader :engine, :contents

  def initialize(csvfile, engine)
    @engine = engine
    @merchants = create_hash_of_merchants(csvfile)
  end

  def create_hash_of_merchants(csvfile)
    all_merchants = {}
    csvfile.each do |row|
      all_merchants[row[:id]] = Merchant.new(row, self)
    end
    all_merchants
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def all
    @merchants.values
  end

  def find_merchant_by_an_item(item_id)
    all.find do |merchant|
        merchant.item_id == item_id
      end
  end

  def find_by_id(id)
    @merchants[id.to_s]
  end

  def find_items_by_merchant_id(merchant_id)
    @engine.items.find_all_items_to_a_merchant(merchant_id)
  end

  def find_by_name(name)
    content_array = all
    content_array.find do |merchant|
      if merchant.name.downcase == name.downcase
        return merchant
      end
    end
  end

  def find_all_by_name(name)
    array_of_matching_merchants = []
    all.find_all do |merchant|
      if merchant.name.downcase.include?(name.downcase)
        array_of_matching_merchants << merchant
      end
    end
    array_of_matching_merchants
  end

end




# def load_merchants(csvfile)
#   contents = CSV.open csvfile, headers: true, header_converters: :symbol
#   all_merchants = {}
#   contents.each do |row|
#     all_merchants[row[:id]] = Merchant.new(row, self)
#   end
#   all_merchants
# end
