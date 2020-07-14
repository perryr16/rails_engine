class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy

  def self.find_all(params)

    where(sql_injection(params))
  end

  def self.sql_injection(params)
    attributes = Merchant.first.attributes if Merchant.first
    search_terms = params.permit(attributes.keys).to_h
    injection = search_terms.map do |k,v|
      param_generator(k,v)
    end
    injection.join(" AND ")
  end

  def self.param_generator(key, value)
    if key.include?('ated_at')
      value = value.to_datetime
      "#{key} >= '#{value}' AND #{key} < '#{value+1.seconds}'"
    else 
      "lower(#{key}) LIKE '%#{value.downcase}%'"
    end
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

    
  def self.most_items(params)
    Merchant.select("merchants.*, SUM(invoice_items.quantity) as items_sold")
    .joins(:invoices)
    .joins("INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id")
    .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
    .where(transactions: {result: "success"})
    .group(:id)
    .order("SUM(invoice_items.quantity) DESC")
    .limit(params[:quantity])
  end

  def self.most_revenue_between_dates(params)
    start_date = params[:start].to_datetime
    end_date = params[:end].to_datetime + 1

    InvoiceItem.select("SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:invoice)
    .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
    .where(transactions: {result: "success"})
    .where("invoices.created_at > '#{start_date}' AND invoices.created_at < '#{end_date}'")[0]
  end


   def self.individual_revenue(params)
    id = params[:id]
    InvoiceItem.select("SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:invoice)
    .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
    .where(transactions: {result: 'success'})
    .where(invoices: {merchant_id: id})[0]
  end

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

     # Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    # Merchant.select("SUM(invoice_items.quantity * invoice_items.unit_price * merchants.id) AS revenue")
    # .joins(:invoices)
    # .joins("INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id")
    # .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
    # .where("invoices.updated_at > '#{start_date}' AND invoices.updated_at < '#{end_date}' AND transactions.result = 'success'")
    # .group(:id)
    # .order("SUM(invoice_items.quantity * invoice_items.unit_price) DESC")
    
    # .where(transactions: {result: "success"})
    # SELECT SUM(ii.quantity * ii.unit_price) AS revenue 
    # FROM merchants as m 
    # INNER JOIN invoices as i ON m.id = i.merchant_id 
    # INNER JOIN invoice_items as ii ON i.id = ii.invoice_id 
    # INNER JOIN transactions as t ON i.id = t.invoice_id 
    # WHERE t.result = 'success';

    # SELECT  SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue 
    # FROM "merchants" 
    # INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" 
    # INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id 
    # INNER JOIN transactions ON invoices.id = transactions.invoice_id 
    # WHERE (transactions.result = 'success') 


    # InvoiceItem.joins(:invoice).joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id").where(transactions: {result: 'success'}).where("invoices.created_at > '2012-01-01' AND invoices.updated_at < '2020-07-15'")
    # InvoiceItem.joins(:invoice).joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id").where(transactions: {result: 'success'}).where("invoices.created_at > '2012-01-01' AND invoices.updated_at < '2020-07-15'").where("invoices.merchant_id = 1") 