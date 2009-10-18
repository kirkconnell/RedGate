gate :mock

process "calculate tax" do |invoice|
  invoice.tax = invoice.sub_total * 0.063
end

receiver "http://localhost:3001/invoices/"

