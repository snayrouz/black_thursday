require_relative 'item_repo'
require_relative 'merchant_repo'
require_relative 'invoice_repo'

class SalesAnalyst

  include Math

  attr_reader :engine

  def initialize(engine)
    @engine = engine
  end

  def average_items_per_merchant
    merchant = @engine.merchants.all
    items    = @engine.items.all
    average  = (items.length.to_f)/(merchant.length)
    average.round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean         = average_items_per_merchant
    actual_diff  = subtract_mean_from_actual(mean, array_of_items_by_merchant)
    squared_diff = square_all_elements(actual_diff)
    sum          = squared_diff.reduce(:+)
    sum_divided  = sum/(array_of_items_by_merchant.length - 1)
    Math.sqrt(sum_divided).round(2)
  end

  def array_of_items_by_merchant
    @engine.merchants.all.map do |merchant|
      @engine.find_items_by_merchant_id(merchant.id).length
    end
  end

  def merchants_with_high_item_count
    std_dev = average_items_per_merchant_standard_deviation
    @engine.merchants.all.find_all do |merchant|
      (merchant.items.count - average_items_per_merchant) > std_dev
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant    = @engine.merchants.find_by_id(merchant_id)
    price_total = price_totaler(merchant)
    return 0 if merchant.items.empty?
    (price_total / merchant.items.count).round(2)
  end

  def average_average_price_per_merchant
    total_average = @engine.merchants.all.reduce(0) do |sum, merchant|
      sum + average_item_price_for_merchant(merchant.id)
    end
    (total_average / @engine.merchants.all.count).round(2)
  end


  def average_item_price
    total_items = @engine.items.all.count
    total_price = item_price_totaler(total_items)
    (total_price / total_items).round(2)
  end

  def average_item_price_standard_deviation
    squared_total = find_standard_deviation_of_averages / (@engine.items.all.count - 1)
    (Math.sqrt(squared_total)).round(2)
  end

  def golden_items
    std_dev = average_item_price_standard_deviation
    average = average_average_price_per_merchant
    find_golden_items(std_dev, average)
  end

  def average_invoices_per_merchant
    merchant = @engine.merchants.all
    invoices = @engine.invoices.all
    average  = (invoices.length.to_f)/(merchant.length)
    average.round(2)
  end

  def array_of_invoices_by_merchant
    @engine.merchants.all.map do |merchant|
      @engine.find_invoices_by_merchant_id(merchant.id).length
    end
  end

  def average_invoices_per_merchant_standard_deviation
      mean         = average_invoices_per_merchant
      actual_diff  = subtract_mean_from_actual(mean, array_of_invoices_by_merchant)
      squared_diff = square_all_elements(actual_diff)
      sum          = squared_diff.reduce(:+)
      sum_divided  = sum/(array_of_invoices_by_merchant.length - 1)
      Math.sqrt(sum_divided).round(2)
  end

  def top_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    mean    = average_invoices_per_merchant
    find_top_merchants_by_invoice_count(std_dev, mean)
  end

  def bottom_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    mean    = average_invoices_per_merchant
    find_bottom_merchants_by_invoice_count(std_dev, mean)
  end

  # def bottom_merchants_by_invoice_count
  # # it "#bottom_merchants_by_invoice_count returns merchants that are two standard deviations below the mean" do
  # # expected = sales_analyst.bottom_merchants_by_invoice_count
  # #
  # # expect(expected.length).to eq 4
  # # expect(expected.first.class).to eq Merchant
  # end
  #
  # def top_days_by_invoice_count
  # #   it "#top_days_by_invoice_count returns days with an invoice count more than one standard deviation above the mean" do
  # # expected = sales_analyst.top_days_by_invoice_count
  # #
  # # expect(expected.length).to eq 1
  # # expect(expected.first).to eq "Wednesday"
  # # expect(expected.first.class).to eq String
  # end
  #
  # def invoice_status(:pending)
  # #   it "#invoice_status returns the percentage of invoices with given status" do
  # # expected = sales_analyst.invoice_status(:pending)
  # #
  # # expect(expected).to eq 29.55
  # end
  #
  # def invoice_status(:shipped)
  # # expected = sales_analyst.invoice_status(:shipped)
  # #
  # # expect(expected).to eq 56.95
  # end
  #
  # def invoice_status(:returned)
  # #
  # # expected = sales_analyst.invoice_status(:returned)
  # #
  # # expect(expected).to eq 13.5
  # end

  private

    def find_standard_deviation_of_averages
      @engine.items.all.reduce(0) do |sum, item|
        sum + (item.unit_price - average_item_price)**2
      end
    end

    def find_golden_items(std_dev, average)
      @engine.items.all.find_all do |item|
        (item.unit_price - average) > (2 * std_dev)
      end
    end

    def find_top_merchants_by_invoice_count(std_dev, average)
      @engine.merchants.all.find_all do |merchant|
        (@engine.find_invoices_by_merchant_id(merchant.id).length - average) > (std_dev * 2)
      end
    end

    def find_bottom_merchants_by_invoice_count(std_dev, average)
      @engine.merchants.all.find_all do |merchant|
        (@engine.find_invoices_by_merchant_id(merchant.id).length + (std_dev *2)) < (average)
      end
    end

    def item_price_totaler(total_items)
      @engine.items.all.reduce(0) do |sum, item|
        sum + item.unit_price
      end
    end

    def price_totaler(merchant)
      merchant.items.reduce(0) do |sum, item|
        sum + item.unit_price
      end
    end

    def subtract_mean_from_actual(mean, sorted_array)
      sorted_array.map do |merchant_items|
        merchant_items - mean
      end
    end

    def square_all_elements(actual_diff)
      actual_diff.map do |num|
        num ** 2
      end
    end

end
