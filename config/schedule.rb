every 1.day, :at => '4:30 am' do
  runner "TokenStorage.where(oauth_provider: 'quickbooks').first.renew"
end