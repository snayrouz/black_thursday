class Merchant
  attr_reader :id, :name, :created_at, :updated_at, :repo

  def initialize(merch_repo, merch_hash)
    @merch_repo = merch_repo
    @id         = merch_hash[:id].to_i
    @name       = merch_hash[:name].to_s
    @created_at = Time.parse(merch_hash[:created_at])
    @updated_at = Time.parse(merch_hash[:updated_at])
  end

  def items
    merch_repo.find_items_by_merchant_id(id)
  end

  def invoices
    merch_repo.find_invoice_by_merchant_id(id)
  end

  def customers
    customer_ids = invoices.map(:customer_id)
    merch_repo.find_all_customers_by_id(customer_ids)
  end

  # def revenue
  #
  # end
  #
  # def invoice_items
  #
  # end



end
