#!/usr/bin/env ruby

begin
  require 'redcloth'
  directory "html"

  desc "Display the README file"
  task :readme => "html/README.html" do
    sh "open html/README.html"
  end

  desc "format the README file"
  task "html/README.html" => ['html', 'README.textile', "readme:update"] do
    open("README.textile") do |source|
      open('html/README.html', 'w') do |out|
        out.write(RedCloth.new(source.read).to_html.gsub(/<br \/>$/,''))
      end
    end
  end

  namespace "readme" do
    desc "Update the version in the readme"
    task :update do
      open("README.textile") do |ins|
        open("new_readme.txt", "w") do |outs|
          while line = ins.gets
            if line =~ /^\*Version: .*\*$/
              line = "*Version: #{PKG_VERSION}*"
            end
            outs.puts line
          end
        end
      end
      mv "README.textile", "README.bak"
      mv "new_readme.txt", "README.textile"
    end
  end

rescue LoadError => ex
  task :readme do
    fail "Install RedCloth to generate the README"
  end
end

