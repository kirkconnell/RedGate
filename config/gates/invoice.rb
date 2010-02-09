gate :invoices

process "filter invalid prices" do |invoice|
  discard if invoice.price < 0.01
end

process "calculate tax" do |invoice|
  invoice.tax = invoice.price * 0.008
  invoice.total = invoice.price + invoice.tax
end

receiver "http://localhost:3002/invoices/"

