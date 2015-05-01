require 'nokogiri'

module Slather
  module CoverageService
    module HtmlOutput

      def coverage_file_class
        Slather::CoverageFile
      end
      private :coverage_file_class

      def html_directory
        "html"
      end
      private :html_directory

      def class_for_coverage_percentage(percentage)
        if percentage > 85
          "cov_high"
        elsif percentage > 70
          "cov_medium"
        else
          "cov_low"
        end
      end

      def post
        create_html_reports(coverage_files)
        generate_reports(@docs)
      end

      def create_html_reports(coverage_files)
        create_index_html(coverage_files)
        create_htmls_from_files(coverage_files)
      end

      def generate_reports(reports)
        directory_path = html_directory
        if output_directory
          directory_path = File.join(output_directory, html_directory)
        end

        FileUtils.rm_rf(directory_path) if File.exists?(directory_path)
        FileUtils.mkdir_p(directory_path)

        css_path = File.join(directory_path, "slather.css")
        css_content = File.read("css/slather.css")
        File.write(css_path, css_content)

        reports.each do |name, doc|
          html_file = File.join(directory_path, "#{name}.html")
          File.write(html_file, doc.to_html)
        end
      end

      def create_index_html(coverage_files)
        project_name = File.basename(self.xcodeproj)
        template = generate_html_template(project_name)

        builder = Nokogiri::HTML::Builder.with(template.at('#coverage')) { |cov|
          total_relevant_lines = 0
          total_tested_lines = 0

          cov.h2 "Files for #{project_name}"

          cov.table(:class => "table", :cellspacing => 0,  :cellpadding => 0) {

            cov.thead {
              cov.tr {
                cov.th "%", :class => "col_num"
                cov.th "File"
                cov.th "Lines", :class => "col_percent"
                cov.th "Relevant", :class => "col_percent"
                cov.th "Covered", :class => "col_percent"
                cov.th "Missed", :class => "col_percent"
              }
            }

            cov.tbody {
              coverage_files.each { |coverage_file|
                filename = File.basename(coverage_file.source_file_pathname_relative_to_repo_root)
                filename_link = "#{filename}.html"

                tested_lines = coverage_file.num_lines_tested
                relevant_lines = coverage_file.num_lines_testable
                total_tested_lines += tested_lines
                total_relevant_lines += relevant_lines

                cov.tr {
                  percentage = coverage_file.percentage_lines_tested
                  cov.td { cov.span '%.2f' % percentage, :class => "percentage #{class_for_coverage_percentage(percentage)}" }
                  cov.td { cov.a filename, :href => filename_link }
                  cov.td "#{coverage_file.line_coverage_data.count}"
                  cov.td "#{relevant_lines}"
                  cov.td "#{tested_lines}"
                  cov.td "#{(relevant_lines - tested_lines)}"
                }
              }
            }
          }

          cov.h3 {
            percentage = (total_tested_lines / total_relevant_lines.to_f) * 100.0
            cov.span "Total Coverage : "
            cov.span '%.2f%%' % percentage, :class => class_for_coverage_percentage(percentage), :id => "total_coverage"
          }
        }

        @docs = Hash.new
        @docs[:index] = builder.doc
      end

      def create_htmls_from_files(coverage_files)
        coverage_files.map { |file| create_html_from_file file }
      end

      def create_html_from_file(coverage_file)
        filepath = coverage_file.source_file_pathname_relative_to_repo_root
        filename = File.basename(filepath)

        template = generate_html_template(filename)

        builder = Nokogiri::HTML::Builder.with(template.at('#coverage')) { |cov|
          cov.h2 "Coverage for #{filename}"
          cov.h4 "File path : #{filepath}"
        }

        @docs[filename] = builder.doc
      end

      def generate_html_template(title)
        builder = Nokogiri::HTML::Builder.new do |doc|
          doc.html {

            doc.head {
              doc.title "Slather - #{title}"
              doc.link :href => "slather.css", :media => "all", :rel => "stylesheet"
            }

            doc.body {
              doc.header {
                doc.div(:class => "row") {
                  doc.img :src => "../docs/logo.jpg", :alt => "Slather logo"
                }
              }

              doc.div(:class => "row") {
                doc.div(:id => "coverage")
              }

              doc.footer {
                doc.div(:class => "row") {
                  doc.p {
                    doc.a "Fork me on Github", :href => "https://github.com/venmo/slather"
                  }
                  doc.p '© 2015 Slather'
                }
              }

            }
          }
        end

        builder.doc
      end

    end
  end
end
