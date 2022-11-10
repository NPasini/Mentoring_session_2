# BeerPackage

## Beer Feature Specs

### Story: Customer requests to see the list of beers

### Narrative #1

```
As an online customer
I want the app to automatically load the list of beers
So I can always get the info related to the whole beers
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see the list of beers
 Then the app should display the all the available beers from remote
```

## Use Cases

### Load Beers From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Beers" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates beers from valid data.
5. System delivers beers.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Beer Image Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---
