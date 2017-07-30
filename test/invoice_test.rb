require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice'


class InvoiceTest < Minitest::Test

  def setup
    invoice = ({:id          => 6,
                :customer_id => 7,
                :merchant_id => 8,
                :status      => :pending,
                :created_at  => "2009-02-07",
                :updated_at  => "2014-03-15" })

    @invoice = Invoice.new(invoice, "Invoice_Repo")
  end

  def test_it_exist
    assert_instance_of Invoice, @invoice
    assert_equal 6, @invoice.id
    assert_equal 7, @invoice.customer_id
    assert_equal :pending , @invoice.status
    assert_instance_of Time, @invoice.created_at
    assert_instance_of Time, @invoice.updated_at
  end

  # def test_merchant_returns_merchant_object
  #
  # end

end
