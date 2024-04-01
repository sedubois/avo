require "rails_helper"

RSpec.feature "Field Sorting", type: :feature do
  let!(:user) { create :user }
  let!(:project) { create :project }
  let!(:amy) { create :person, name: "amy" }
  let!(:bob) { create :person, name: "Bob" }
  let!(:cathy) { create :person, name: "Cathy" }

  describe "sortable field option" do
    it "provides the ability to sort by the ID field by default" do
      visit avo.resources_projects_path

      expect(page).not_to have_css 'th[data-control="resource-field-th"][data-table-header-field-id="id"][data-table-header-field-type="id"] div[data-sortable="false"]'
      expect(page).to have_css 'th[data-control="resource-field-th"][data-table-header-field-id="id"][data-table-header-field-type="id"] div a svg'
    end

    it "hides the ability to sort by the id field" do
      visit avo.resources_users_path

      expect(page).to have_css 'th[data-control="resource-field-th"][data-table-header-field-id="id"][data-table-header-field-type="id"] div[data-sortable="false"]'
      expect(page).not_to have_css 'th[data-control="resource-field-th"][data-table-header-field-id="id"][data-table-header-field-type="id"] a svg'
    end

    it "sorts text while ignoring case" do
      visit avo.resources_people_path(sort_by: "name", sort_direction: "asc")

      expect(page).to have_css 'th[data-control="resource-field-th"][data-table-header-field-id="name"][data-table-header-field-type="text"]'
      within "turbo-frame#people_list tbody" do
        expect(page).to have_css "tr[data-resource-id=#{amy.id}] + tr[data-resource-id=#{bob.id}] + tr[data-resource-id=#{cathy.id}]"
      end
    end
  end
end
