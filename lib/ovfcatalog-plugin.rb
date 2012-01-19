require 'rubygems'
require 'diskid'
require 'curb'
require 'boxgrinder-build/plugins/base-plugin'

module BoxGrinder
  class OVFCatalog < BasePlugin
    plugin :type => :delivery, :name => :ovfcatalog, :full_name  => "Upload appliance to Abiquo OVFCatalog"

    def validate
      set_default_config_value('category', 'Misc')
      set_default_config_value('name', @appliance_config.name)
      set_default_config_value('description', "#{@appliance_config.name}-#{@appliance_config.version}.#{@appliance_config.release}-#{@appliance_config.os.name}-#{@appliance_config.os.version}-#{@appliance_config.hardware.arch}")
      set_default_config_value('port', '9000')
      set_default_config_value('ram', '512')
      set_default_config_value('cpu', '1')
      set_default_config_value('host', 'rs.bcn.abiquo.com')
      set_default_config_value('icon_path', 'http://rs.bcn.abiquo.com:9000/public/icons/q.png')
    end

    def execute
      @log.info "Uploading #{@appliance_config.name} to OVFCatalog..."
      begin
        #TODO move to a block
        upload_files(@previous_deliverables[:disk])
        @log.info "Appliance #{@appliance_config.name} uploaded."
      rescue => e
        @log.error e
        @log.error "An error occurred while uploading files."
      end
    end
    
    def upload_files(disk_file)
      server_host = @plugin_config['host']
      server_port = @plugin_config['port']
      name = @plugin_config['name']
      ram = @plugin_config['ram']
      cpu = @plugin_config['cpu']
      category = @plugin_config['category']
      icon_path = @plugin_config['icon_path']
      description = "#{@appliance_config.name}-#{@appliance_config.version}.#{@appliance_config.release}-#{@appliance_config.os.name}-#{@appliance_config.os.version}-#{@appliance_config.hardware.arch}"
      disk_info = DiskID::Client.identify(disk_file)
      units = disk_info['virtual_size'].gsub(/[0-9]|\./,'')
      virtual_size = disk_info['virtual_size'].gsub(/G|M/,'')
      if units == 'G'
        vsbytes = virtual_size.to_f * 1024 * 1024 * 1024
      else
        vsbytes = virtual_size.to_f * 1024 * 1024
      end
      puts "Name:".ljust(40) + name
      puts "Description:".ljust(40) + description
      puts "Category:".ljust(40) + category
      puts "RAM:".ljust(40) + "#{ram} MB"
      puts "CPU:".ljust(40) + cpu
      puts "HD:".ljust(40) + "#{virtual_size} #{units} (#{vsbytes} bytes)"
      puts "Filesize:".ljust(40) + "#{FileTest.size(disk_file)} bytes"
      c = Curl::Easy.new "http://#{server_host}:#{server_port}/createOvf"
      c.multipart_form_post = true
      c.on_progress { |dt, dn, ut, un| print "\r\e[0KUploading disk: %.0f%" % ((un*100)/ut); true }
      c.http_post Curl::PostField.content('object.diskFilePath', disk_file),
                  Curl::PostField.content('object.diskFileSize', FileTest.size(disk_file).to_s),
                  Curl::PostField.content('object.diskFileFormat', guess_format(disk_file)),
                  Curl::PostField.content('object.name', name),
                  Curl::PostField.content('object.description', description),
                  Curl::PostField.content('object.categoryName', category),
                  Curl::PostField.content('object.iconPath', icon_path),
                  Curl::PostField.content('object.cpu', cpu),
                  Curl::PostField.content('object.ram', ram),
                  Curl::PostField.content('object.ramSizeUnit', "MB"),
                  Curl::PostField.content('object.hd', virtual_size),
                  Curl::PostField.content('object.hdSizeUnit', "#{units}B"),
                  Curl::PostField.content('object.hdInBytes', vsbytes.to_s ),
                  Curl::PostField.file('diskFile', disk_file)
      puts
    end

    def guess_format(file)
      format_map = {
        "vmdk_streamOptimized" => "VMDK_STREAM_OPTIMIZED",
        "qcow2" => "QCOW2_SPARSE",
        "vmdk_monolithicSparse" => "VMDK_SPARSE"
      }
      f = DiskID::Client.identify(file)
      fstring = ''
      if f['format'] == 'vmdk'
        fstring = format_map["vmdk_#{f['variant']}"]
      elsif f['format'] == 'qcow2'
        fstring = "QCOW2_SPARSE"
      else
      end
      fstring
    end

  end
end

