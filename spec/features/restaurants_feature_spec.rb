require 'rails_helper'

feature 'restaurants' do
  before do
    visit('/')
    click_link "Sign up"
    fill_in("Email", with: "test@test.com")
    fill_in("Password", with: "testtest")
    fill_in("Password confirmation", with: "testtest")
    click_button("Sign up")
  end
  context 'no restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content("No restaurants yet!")
    end

  end

  context 'creating restaurants' do

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

    context 'when not signed in' do
      scenario 'it does not let you sign in' do
        click_link("Sign out")
        click_link "Add a restaurant"
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name: 'KFC')}
    scenario 'let a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
    before do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    context "when signed in" do
      it "should not allow you to delete a restaurant you didn't create" do
        visit '/restaurants'
        click_link "Sign out"
        click_link "Sign up"
        fill_in("Email", with: "test222@test.com")
        fill_in("Password", with: "testtest22")
        fill_in("Password confirmation", with: "testtest22")
        click_button("Sign up")
        expect(current_path).to eq '/'
        expect(page).not_to have_link "Delete KFC"
      end
    end
  end

  scenario 'should display a prompt to add a restaurant' do
    visit '/restaurants'
    expect(page).to have_content "No restaurants yet"
    expect(page).to have_link 'Add a restaurant'
  end


end
