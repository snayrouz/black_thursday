class MerchantRepository
  attr_reader :merchants

  def initialize(csv_data, engine)
    @engine = engine
    @merchants = csv_data
  end

  def all
    merchants
  end

  def find_by_id
  # returns either nil or an instance of Merchant with a matching ID
  end

  def find_by_name
  # returns either nil or an instance of Merchant having done a case insensitive search
  end

  def find_all_by_name
  # returns either [] or one or more matches which contain the supplied name fragment, case insensitive
  end

end
