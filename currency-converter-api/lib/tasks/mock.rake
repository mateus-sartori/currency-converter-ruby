require 'tty-prompt'

namespace :mock do
  desc 'Create a new mock in app/mocks'
  task create: :environment do
    prompt = TTY::Prompt.new

    class_name = prompt.ask('Enter the mock class name (in CamelCase):') do |q|
      q.required true
      q.validate(/^[A-Z][a-zA-Z0-9]*$/)
      q.messages[:valid?] = 'Invalid class name. Please use CamelCase.'
    end

    raise StandardError, 'You are not running in development environment' unless Rails.env.development?

    filename = format_filename(class_name)
    raise StandardError, 'Invalid filename for mock creation' unless valid_filename?(filename)

    file_path = "app/mocks/#{filename}.rb"
    File.write(file_path, generate_code_inside(class_name))
    show_message("A new mock was created in #{file_path}", true)
  end

  desc 'Run a mock to execute the block code specified in the mock file'
  task run: :environment do
    prompt = TTY::Prompt.new

    class_name = prompt.ask('Enter the name of the mock class to run (in CamelCase):') do |q|
      q.required true
      q.validate(/^[A-Z][a-zA-Z0-9]*$/)
      q.messages[:valid?] = 'Invalid class name. Please use CamelCase.'
    end

    raise StandardError, 'You are not running in development environment' unless Rails.env.development?

    mock_class_name = "#{remove_mock_suffix(class_name).camelize}Mock"
    mock_class = mock_class_name.safe_constantize

    raise StandardError, "Mock class #{mock_class_name} not found" unless mock_class&.is_a?(Class)

    mock_class.new
    show_message("Executed mock: #{mock_class_name}", true)
  end

  private

  def show_message(msg_start, status)
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    status ? spinner.success : spinner.error
  end

  def generate_code_inside(class_name)
    <<~HEREDOC.strip
      class #{class_name}Mock
        # Don't delete the initialize, we need to call the mock and execute the block code
        def initialize
          # Build your code and make sure the calls are being initiated by the constructor
        end
      end
    HEREDOC
  end

  def format_filename(class_name)
    class_name = remove_mock_suffix(class_name)
    "#{class_name.underscore}_mock"
  end

  def remove_mock_suffix(name)
    name.gsub(/Mock\z/, '')
  end

  def valid_filename?(filename)
    filename.present? && filename.match?(/[[:alnum:]]/)
  end
end
