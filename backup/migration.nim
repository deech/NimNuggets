import migrationmacros

type
  Person = object
    firstName: string
    lastName: string
  PersonV1 = object
    firstName: string
    middleName: string
    lastName: string
    address: string

type
  Address = object
    street: string
    city: string
    zip: string
  PersonV2 = object
    firstName: string
    middleName: string
    lastName: string
    address: Address

let p = Person(firstName: "Namey", lastName: "McNameface")

let personMigrate : diffType(Person,PersonV1) =
  (middleName: "Danger", address: "An address")

let person1 = migrate(p,PersonV1,personMigrate)

let person2Migrate : diffType(PersonV1,PersonV2) =
  (address: proc(address:string):Address {.closure.} =
                Address(street: "This", city: "will", zip: "suck"))

let person2 = migrate(person1,PersonV2,person2Migrate)
echo person2
