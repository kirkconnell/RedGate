gate :invoices

process "calculate tax" do |invoice|
  invoice.tax = invoice.price * 0.008
  invoice.total = invoice.price + invoice.tax
end

receiver "http://localhost:3002/invoices/"

