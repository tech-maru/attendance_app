# coding: utf-8

User.create!(name: "Admin User",
             email: "sample1@email.com",
             employee_number: "1",
             affiliation: "管理者",
             password: "sample1@email.com",
             password_confirmation: "sample1@email.com",
             admin: "true")
             
User.create!(name: "上長B",
             email: "sample2@email.com",
             employee_number: "2",
             affiliation: "技術部",
             basic_work_time: "7:00:00.000000",
             designated_work_start_time: "10:00:00.000000",
             designated_work_end_time: "17:00:00.000000",
             password: "sample2@email.com",
             password_confirmation: "sample2@email.com",
             superior: "true",
             admin: "false")

User.create!(name: "上長A",
             email: "sample3@email.com",
             employee_number: "3",
             affiliation: "営業部",
             basic_work_time: "7:00:00.000000",
             designated_work_start_time: "10:00:00.000000",
             designated_work_end_time: "17:00:00.000000",
             password: "sample3@email.com",
             password_confirmation: "sample3@email.com",
             superior: "true",
             admin: "false")

10.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+2}@email.com"
  employee_number = "#{n+4}"
  basic_work_time = "7:00:00.000000"
  designated_work_start_time = "10:00:00.000000"
  designated_work_end_time = "17:00:00.000000"
  password = "sample-#{n+2}@email.com"
  User.create!(name: name,
               email: email,
               employee_number: employee_number,
               basic_work_time: basic_work_time,
               designated_work_start_time: designated_work_start_time,
               designated_work_end_time: designated_work_end_time,
               password: password,
               password_confirmation: password,
               admin: "false")
end