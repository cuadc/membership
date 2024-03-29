cj = User.create(name: "Charlie Jonas", email: "charlie@charliejonas.co.uk", sysop: true)
ProviderAccount.create(provider: "ucam-raven", uid: "chtj2", user: cj)

Type.create(id: 1, name: "Ordinary")
Type.create(id: 2, name: "Associate")
Type.create(id: 3, name: "Special")
Type.create(id: 4, name: "Honorary")
Type.create(id: 5, name: "Suspended")
Type.create(id: 6, name: "Banned")
Type.create(id: 998, name: "Awaiting Email Verification")
Type.create(id: 999, name: "Awaiting Payment")

Institution.create(id: 1, name: "ADC Theatre")
Institution.create(id: 2, name: "Anglia Ruskin University")
Institution.create(id: 3, name: "Christ's College")
Institution.create(id: 4, name: "Churchill College")
Institution.create(id: 5, name: "Clare College")
Institution.create(id: 6, name: "Clare Hall")
Institution.create(id: 7, name: "Corpus Christi College")
Institution.create(id: 8, name: "Darwin College")
Institution.create(id: 9, name: "Downing College")
Institution.create(id: 10, name: "Emmanuel College")
Institution.create(id: 11, name: "Fitzwilliam College")
Institution.create(id: 12, name: "Girton College")
Institution.create(id: 13, name: "Gonville and Caius")
Institution.create(id: 14, name: "Homerton College")
Institution.create(id: 15, name: "Hughes Hall")
Institution.create(id: 16, name: "Jesus College")
Institution.create(id: 17, name: "King's College")
Institution.create(id: 18, name: "Lucy Cavendish")
Institution.create(id: 19, name: "Magdalene College")
Institution.create(id: 20, name: "Murray Edwards")
Institution.create(id: 21, name: "Newnham College")
Institution.create(id: 22, name: "Pembroke College")
Institution.create(id: 23, name: "Peterhouse College")
Institution.create(id: 24, name: "Queens' College")
Institution.create(id: 25, name: "Robinson College")
Institution.create(id: 26, name: "St. Catharine's College")
Institution.create(id: 27, name: "St. Edmund's College")
Institution.create(id: 28, name: "St. John's College")
Institution.create(id: 29, name: "Selwyn College")
Institution.create(id: 30, name: "Sidney Sussex")
Institution.create(id: 31, name: "Trinity College")
Institution.create(id: 32, name: "Trinity Hall")
Institution.create(id: 33, name: "Wolfson College")
Institution.create(id: 34, name: "University Department/Faculty")
Institution.create(id: 35, name: "Unknown")
Institution.create(id: 36, name: "Cambridge School of Visual and Performing Arts")
Institution.create(id: 37, name: "Cambridge Regional College")
Institution.create(id: 38, name: "Bodywork Dance Studios")
Institution.create(id: 39, name: "Institute of Continuing Education")
