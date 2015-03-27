@availability @availability_dataformcontent
Feature: availability_dataformcontent
    In order to control student access to activities from a Dataform dashboard
    As a teacher
    I need to set dataformcontent conditions which prevent student access

    Background:
    Given a fresh site for dataform scenario

    And I log in as "admin"
    And I set the following administration settings values:
        | Enable conditional access  | 1 |
    And I log out

    @javascript
    Scenario: Test condition

    #Section: Teacher set up.
    Given I log in as "teacher1"

        #Section: Add a dashboard dataform.
        And I follow "Course 1"
        And I turn editing mode on

        And I add a "Dataform" to section "1"
        And I expand all fieldsets
        And I set the following fields to these values:
          | Name                    | Dashboard |
          | Description             | Test      |
          | Separate participants   | Yes       |
        And I press "Save and display"

        # Add fields.
        And I go to manage dataform "fields"
        And I set the field "Add a field" to "text"
        And I set the field "Name" to "Conditional activity"
        And I press "Save changes"

        And I set the field "Add a field" to "time"
        And I set the field "Name" to "From"
        And I press "Save changes"

        And I set the field "Add a field" to "time"
        And I set the field "Name" to "To"
        And I press "Save changes"

        # Add views.
        And I go to manage dataform "views"
        And I set the field "Add a view" to "aligned"
        And I expand all fieldsets
        And I set the field "Name" to "List"
        And I set the field "View template" to "##entries##"
        And I set the field "savebuttonenable" to ""
        And I set the field "cancelbuttonenable" to ""
        And I press "Save changes"

        And I set "List" as default view

        And I set the field "Add a view" to "aligned"
        And I expand all fieldsets
        And I set the field "Name" to "Manage List"
        And I replace in field "Entry template" "[[EAU:name]]" with "[[EAU:edit]]"
        And I press "Save changes"
        #:Section

        #Section: Add a conditional Page.
        And I follow "Course 1"
        And I turn editing mode on

        And I add a "Page" to section "2"
        And I set the following fields to these values:
          | Name         | Extra Page |
          | Description  | Test   |
          | Page content | Test   |
        And I expand all fieldsets
        And I click on "Add restriction..." "button"
        And I click on "Dataform content" "button" in the "Add restriction..." "dialogue"
        And I click on ".availability-item .availability-eye img" "css_element"
        And I set the field "Dataform content" to "Dashboard"
        And I press "Save and return to course"
        #:Section

    And I log out
    #:Section

    #Section: Student 1 cannot yet see the extra page.
    When I log in as "student1"
    And I follow "Course 1"
    Then I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Student 2 cannot yet see the extra page.
    When I log in as "student2"
    And I follow "Course 1"
    Then I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Teacher grants access to Student 1.
    Then I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Dashboard"
    And I follow "Manage List"
    And I follow "Add a new entry"
    And I set the field "entry_-1_userid" to "Student 1"
    And I set the field "field_1_-1" to "Extra Page"
    And I press "Save"
    And I log out
    #:Section

    #Section: Student 1 can now see the extra page.
    When I log in as "student1"
    And I follow "Course 1"
    Then I should see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Student 2 cannot yet see the extra page.
    When I log in as "student2"
    And I follow "Course 1"
    Then I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Teacher adds a filter on from to time.
    Then I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Dashboard"
    And I go to manage dataform "filters"
    And I follow "Add a filter"
    And I set the field "Name" to "Availability"
    And I set search criterion "1" to "AND" "2,content" "" "<=" "now"
    And I set search criterion "2" to "AND" "3,content" "" ">=" "now"
    And I press "Save changes"
    And I log out
    #:Section

    #Section: Student 1 cannot see the extra page.
    When I log in as "student1"
    And I follow "Course 1"
    Then I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Student 2 cannot see the extra page.
    When I log in as "student2"
    And I follow "Course 1"
    Then I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Teacher grants access to Student 2.
    Then I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Dashboard"
    And I follow "Manage List"
    And I follow "Add a new entry"
    And I set the field "entry_-1_userid" to "Student 2"
    And I set the field "field_1_-1" to "Extra Page"
    And I set the field "field_2_-1[enabled]" to "checked"
    And I set the field "field_2_-1[year]" to "2010"
    And I set the field "field_3_-1[enabled]" to "checked"
    And I set the field "field_3_-1[year]" to "2020"
    And I press "Save"
    And I log out
    #:Section

    #Section: Student 1 cannot see the extra page.
    When I log in as "student1"
    And I follow "Course 1"
    Then I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Student 2 can now see the extra page.
    When I log in as "student2"
    And I follow "Course 1"
    Then I should see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Teacher duplicates the extra page.
    Then I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on

    And I duplicate "Extra Page" activity
    And I wait until section "2" is available
    And I log out
    #:Section

    #Section: Student 1 cannot see either page.
    When I log in as "student1"
    And I follow "Course 1"
    Then I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Student 2 can see both pages.
    When I log in as "student2"
    And I follow "Course 1"
    Then I should see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Teacher adjusts original page name.
    Then I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on

    And I open "Extra Page" actions menu
    And I click on "Edit settings" "link" in the "Extra Page" activity
    And I set the following fields to these values:
      | Name | Extra Original Page |
    And I press "Save and return to course"
    And I log out
    #:Section

    #Section: Student 1 cannot see both pages.
    When I log in as "student1"
    And I follow "Course 1"
    Then I should not see "Extra Original Page" in the "region-main" "region"
    And I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Student 2 can see only the new Extra Page.
    When I log in as "student2"
    And I follow "Course 1"
    Then I should not see "Extra Original Page" in the "region-main" "region"
    And I should see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Teacher grants access to Original for Student 1.
    Then I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Dashboard"
    And I follow "Manage List"
    And I follow "Add a new entry"
    And I set the field "entry_-1_userid" to "Student 1"
    And I set the field "field_1_-1" to "Extra Original Page"
    And I set the field "field_2_-1[enabled]" to "checked"
    And I set the field "field_2_-1[year]" to "2010"
    And I set the field "field_3_-1[enabled]" to "checked"
    And I set the field "field_3_-1[year]" to "2020"
    And I press "Save"
    And I log out
    #:Section

    #Section: Student 1 can now see the original but not the new one.
    When I log in as "student1"
    And I follow "Course 1"
    Then I should see "Extra Original Page" in the "region-main" "region"
    And I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Admin copies Course 1 to Course 2.
    And I log in as "admin"
    And I follow "Course 1"
    And I backup "Course 1" course using this options:
      | Confirmation | Filename | test_backup.mbz |
    And I restore "test_backup.mbz" backup into a new course using this options:
      | Schema | Course name | Course 2 |
    And I log out
    #:Section

    #Section: Student 1 in Course 2 can see the original but not the new one.
    When I log in as "student1"
    And I follow "Course 2"
    Then I should see "Extra Original Page" in the "region-main" "region"
    And I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section

    #Section: Teacher in Course 2 grants access to Extra Page for Student 1.
    Then I log in as "teacher1"
    And I follow "Course 2"
    And I follow "Dashboard"
    And I follow "Manage List"
    And I follow "Add a new entry"
    And I set the field "entry_-1_userid" to "Student 1"
    And I set the field "field_4_-1" to "Extra Page"
    And I set the field "field_5_-1[enabled]" to "checked"
    And I set the field "field_5_-1[year]" to "2010"
    And I set the field "field_6_-1[enabled]" to "checked"
    And I set the field "field_6_-1[year]" to "2020"
    And I press "Save"
    And I log out
    #:Section

    #Section: Student 1 in Course 2 can see both pages but Course 1 only the original.
    When I log in as "student1"
    And I follow "Course 2"
    Then I should see "Extra Original Page" in the "region-main" "region"
    And I should see "Extra Page" in the "region-main" "region"

    And I am on homepage
    And I follow "Course 1"
    Then I should see "Extra Original Page" in the "region-main" "region"
    And I should not see "Extra Page" in the "region-main" "region"
    And I log out
    #:Section




