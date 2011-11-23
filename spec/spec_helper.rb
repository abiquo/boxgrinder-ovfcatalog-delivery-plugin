require 'rubygems'
require 'rspec/autorun'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib-here'

module TestHelpersMod
  
  def data_dir 
    File.join(File.dirname(__FILE__),"data")
  end

end
