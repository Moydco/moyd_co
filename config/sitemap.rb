# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://moyd.co"
SitemapGenerator::Sitemap.public_path = 'public/'

SitemapGenerator::Sitemap.create do
  add support_statics_path, :priority => 0.7, :changefreq => 'daily'
  add team_statics_path, :priority => 0.7, :changefreq => 'daily'
  add contact_us_statics_path, :priority => 0.7, :changefreq => 'daily'
end
