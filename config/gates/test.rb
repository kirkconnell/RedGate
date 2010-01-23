gate :tests

process "sign the message" do |test|
  test.body << ". Signed by RedGate."
end

receiver "http://localhost:3002/tests/"