# spec/helpers/flash_helper_spec.rb

require 'rails_helper'

RSpec.describe FlashHelper, type: :helper do
  describe '#flash_messages' do
    it 'displays flash messages with correct CSS classes' do
      flash[:notice] = 'This is a notice message.'
      flash[:warning] = 'This is a warning message.'
      flash[:alert] = 'This is an alert message.'

      expect(helper.flash_messages).to include('<div class="py-2 px-3 mb-5 font-medium rounded-lg flex flex-row w-full bg-green-50 text-green-500">This is a notice message.</div>')
      expect(helper.flash_messages).to include('<div class="py-2 px-3 mb-5 font-medium rounded-lg flex flex-row w-full bg-yellow-50 text-yellow-500">This is a warning message.</div>')
      expect(helper.flash_messages).to include('<div class="py-2 px-3 mb-5 font-medium rounded-lg flex flex-row w-full bg-red-50 text-red-500">This is an alert message.</div>')
    end

    it 'does not display flash messages if flash is empty' do
      expect(helper.flash_messages).to be_nil
    end
  end
end
