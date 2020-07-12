class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy

  def self.find_all(params)
    where('lower(name) like ?', "%#{params[:name].downcase}%")
  end

  def self.find_one(params)
    find_all(params).first
  end

  def self.most_revenue(params)
    Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:invoices)
    .joins("INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id")
    .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
    .where(transactions: {result: "success"})
    .group(:id)
    .order("SUM(invoice_items.quantity * invoice_items.unit_price) DESC")
    .limit(params[:quantity])
  end

    
    # SELECT m.name, SUM(ii.quantity * ii.unit_price) AS revenue 
    # FROM merchants as m 
    # INNER JOIN invoices as i 
    #   ON m.id = i.merchant_id 
    # INNER JOIN invoice_items as ii 
    #   ON i.id = ii.invoice_id 
    # INNER JOIN transactions as t 
    #   ON i.id = t.invoice_id 
    # WHERE t.result = 'success' 
    # GROUP BY m.name 
    # ORDER BY revenue 
    # DESC LIMIT 7;

      # Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(:invoices).joins("INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id").joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id").where(transactions: {result: "success"}).group(:id).order("SUM(invoice_items.quantity * invoice_items.unit_price) DESC").limit(5)

  def self.most_items(params)
    Merchant.select("merchants.*, SUM(invoice_items.quantity) as items_sold")
    .joins(:invoices)
    .joins("INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id")
    .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
    .where(transactions: {result: "success"})
    .group(:id)
    .order("SUM(invoice_items.quantity) DESC")
    .limit(params[:quantity])
    # SELECT m.*, SUM(ii.quantity) as items_sold 
    # FROM merchants as m 
    # INNER JOIN invoices as i 
    # ON m.id = i.merchant_id 
    # INNER JOIN invoice_items as ii 
    # ON i.id = ii.invoice_id 
    # INNER JOIN transactions as t 
    # ON i.id = t.invoice_id 
    # WHERE t.result = 'success' 
    # GROUP BY m.id 
    # ORDER BY items_sold 
    # DESC LIMIT 5;
  end

  def self.most_revenue_between_dates(params)
    start_date = params[:start]
    end_date = params[:end]
    Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:invoices)
    .joins("INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id")
    .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
    .where("transactions.created_at >= '#{start_date}' AND transactions.created_at <= '#{end_date}' AND transactions.result = 'success'")
    .group(:id)
    .order("SUM(invoice_items.quantity * invoice_items.unit_price) DESC")

        # .where(transactions: {result: "success"})
  end
end
# SELECT m.name, SUM(ii.quantity * ii.unit_price) AS revenue 
# FROM merchants as m 
# INNER JOIN invoices as i 
# ON m.id = i.merchant_id 
# INNER JOIN invoice_items as ii 
# ON i.id = ii.invoice_id 
# INNER JOIN transactions as t 
# ON i.id = t.invoice_id 
# WHERE t.result = 'success' AND t.updated_at BETWEEN '2012-03-25' AND '2013-03-25' 
# GROUP BY m.name 
# ORDER BY revenue 
# DESC LIMIT 7;


    # SELECT m.name, SUM(ii.quantity * ii.unit_price) AS revenue FROM merchants as m INNER JOIN invoices as i ON m.id = i.merchant_id INNER JOIN invoice_items as ii ON i.id = ii.invoice_id INNER JOIN transactions as t ON i.id = t.invoice_id WHERE t.result = 'success' GROUP BY m.name ORDER BY revenue DESC LIMIT 7;
