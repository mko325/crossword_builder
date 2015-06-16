require 'fox16'
include Fox
require 'fox16/colors'


class CrosswordBuilderWindow < FXMainWindow
  def initialize(app)
    super(app, 'Crossword Builder', :width => 1000, :height => 550)

    hframe = FXHorizontalFrame.new(self)
    mtx = FXMatrix.new(hframe, 10)

    vframe = FXVerticalFrame.new(hframe)

    # title
    title = FXLabel.new(vframe, "Crossword Builder", :width => 435, :height => 30, :padLeft => 150, :padRight => 200)
    title.textColor = FXColor::Red

    # word helper box
    word_finder_title = FXLabel.new(vframe, "Word Finder", :width => 435, :height => 30, :padLeft => 170, :padRight => 180)
    word_finder_title.justify = JUSTIFY_CENTER_X|JUSTIFY_CENTER_Y
    word_finder_title.textColor = FXColor::NavyBlue

    # ask user what word they're looking for
    word_finder_instructions = FXLabel.new(vframe, "Input your missing word. Please use the correct letter for any filled
in spaces and a . for any unknown letters.")
    pattern = nil
    word_input = FXTextField.new(vframe, 10, :target => pattern, :opts => LAYOUT_FIX_HEIGHT|LAYOUT_FIX_WIDTH, :height => 30, :width => 435)

    # create list of suggested words
    suggested_words = FXList.new(vframe, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT, :width => 435, :height => 100)
    suggested_words.appendItem("Suggested Words")

    word_input.connect(SEL_KEYRELEASE) do
      pattern = word_input.text.chomp

      # input letters and dots and find all words that you could use to fill in dots
      f = File.new("english_dictionary.txt", "r")
      dictionary = f.read
      word = dictionary.split("\r\n")
      f.close

      suggested_words.clearItems
      suggested_words.appendItem("Suggested Words")

      regexp = /^#{pattern}$/
      word.each do |word|
        if word.to_s =~ regexp
          suggested_words.appendItem(word)
        end
      end
    end

    group1 = FXGroupBox.new(vframe, "Black Box or Input Letter", :opts => GROUPBOX_TITLE_CENTER|FRAME_RIDGE)
    group1_dt = FXDataTarget.new(0)
    blackbox_btn = FXRadioButton.new(group1, "Black Box", group1_dt, FXDataTarget::ID_OPTION)
    input_letter_btn = FXRadioButton.new(group1, "Input Letter", group1_dt, FXDataTarget::ID_OPTION + 1)

    100.times do
      btn = FXButton.new(mtx, '', :opts => BUTTON_NORMAL|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT, :width => 50, :height => 50)
      btn.backColor = "White"
      color = "Black"
      btn.connect(SEL_COMMAND) do
        case group1_dt.value
          when 0
            btn.backColor = color
          when 1
            input_letter = FXInputDialog.getString("Enter some text...", app, "Input Letter", "Please type in a letter:")
            btn.text = input_letter
        end
      end
    end
  end

  # don't touch this
  def create
    super
    self.show(PLACEMENT_SCREEN)
  end
end

# never touch these
app = FXApp.new
CrosswordBuilderWindow.new(app)
app.create
app.run
