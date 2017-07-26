require 'time'

class Invoice

  def initialize(invoice_hash, invoice_repo)
    @id = invoice_hash[:id]
    @customer_id = invoice_hash[:customer_id]
    @merchant_id = invoice_hash[:merchant_id]
    @status = invoice_hash[:status]
    @created_at = Time.now
    @updated_at = Time.now
  end

end
