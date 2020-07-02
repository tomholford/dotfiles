%w{amazing_print irbtools}.each do |lib| 
  begin 
    require lib 
  rescue LoadError => err
    $stderr.puts "Couldn't load #{lib}: #{err}"
  end
end

