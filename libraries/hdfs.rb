#
# Cookbook Name:: hadoop
# Library:: hdfs
#
# Copyright © 2014 Cask Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Hadoop
  # Module for HDFS operations
  module Hdfs
    # See if a path exists in HDFS
    #
    # @result Boolean
    def exist?(path)
      cmd = "hdfs dfs -test -e #{path}"
      mso = Mixlib::ShellOut.new(cmd)
      mso.run_command
      Chef::Log.debug("Hadoop::Hdfs.exist? #{path}")
      begin
        mso.error!
        true
      rescue
        false
      end
    end

    # Determine if an HDFS path is a directory
    #
    # @result Boolean
    def directory?(path)
      cmd = "hdfs dfs -test -d #{path}"
      mso = Mixlib::ShellOut.new(cmd)
      mso.run_command
      Chef::Log.debug("Hadoop::Hdfs.directory? #{path}")
      begin
        mso.error!
        true
      rescue
        false
      end
    end

    # Determine if an HDFS path is a file
    #
    # @result Boolean
    def file?(path)
      cmd = "hdfs dfs -test -f #{path}"
      mso = Mixlib::ShellOut.new(cmd)
      mso.run_command
      Chef::Log.debug("Hadoop::Hdfs.file? #{path}")
      begin
        mso.error!
        true
      rescue
        false
      end
    end

    # Change group of an HDFS path
    #
    # @result Boolean
    def chgrp(path, group, recursive = false)
      opts = '-R ' if recursive
      cmd = "hdfs dfs -chgrp #{opts}#{group} #{path}"
      mso = Mixlib::ShellOut.new(cmd)
      mso.run_command
      Chef::Log.debug("Hadoop::Hdfs.chgrp #{group} #{path}")
    end

    # Change owner of an HDFS path
    #
    # @result Boolean
    def chown(path, owner, recursive = false)
      opts = '-R ' if recursive
      cmd = "hdfs dfs -chown #{opts}#{owner} #{path}"
      mso = Mixlib::ShellOut.new(cmd)
      mso.run_command
      Chef::Log.debug("Hadoop::Hdfs.chown #{owner} #{path}")
    end

    # Change mode of an HDFS path
    #
    # @result Boolean
    def chmod(path, mode, recursive = false)
      opts = '-R ' if recursive
      cmd = "hdfs dfs -chmod #{opts}#{mode} #{path}"
      mso = Mixlib::ShellOut.new(cmd)
      mso.run_command
      Chef::Log.debug("Hadoop::Hdfs.chmod #{mode} #{path}")
    end

    # Get permissions from an HDFS path
    #
    # @result String
    def hdfs_perms(path)
      if self.directory?(path)
        cmd = "hdfs dfs -ls #{::File.dirname(path)} | grep #{::File.basename(path)} | awk '{print $1}'".chomp
      elsif self.file?(path)
        cmd = "hdfs dfs -ls #{path} | awk '{print $1}'".chomp
      else
        Chef::Application.fatal!("Cannot get permissions for #{path}")
      end
      mso = Mixlib::ShellOut.new(cmd)
      mso.run_command
      mso.stdout # | awk '{k=0; for(i=0;i<=8;i++) k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if (k) printf(" %0o ",k); print}'
    end
  end
end
