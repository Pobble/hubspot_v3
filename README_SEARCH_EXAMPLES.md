


### Find by primary email

```
bodyhash = {
  "filterGroups":[
    {
      "filters": [
        {
          "propertyName": "email",
          "operator": "EQ",
          "value": "equivalent@eq8.eu"
        }
      ]
    }
  ]
}
HubspotV3.contacts_search(bodyhash)
```



### Find contacts that have multiple emails

Let say you want a list of all Hubspot Contacts that have secondary
email.

```
  bodyhash = {
    "filterGroups":[
      {
        "filters": [
          {
            "propertyName": "hs_additional_emails",
            "operator": "HAS_PROPERTY"
          }
        ]
      }
    ],
    "properties": [
      "hs_additional_emails",
      "email"
    ],
    "limit": 99,
    "after": 0
  }

  a= HubspotV3.contacts_search(bodyhash)
```

Now you can map these to a CSV:


```
  # vid,primary_email,secondary_emails
  a.map do |res|
    [res.fetch('id'), res.fetch('properties').fetch('email'), res.fetch('properties').fetch('hs_additional_emails')]
  end
```



## More info


Full list of search filters and operators can be found in [official hubspot docs](https://developers.hubspot.com/docs/api/crm/contacts)

![Screenshot from 2021-11-25 12-04-08](https://user-images.githubusercontent.com/721990/143430312-4d94aa49-5d8e-4910-8076-628b62a7a954.png)


