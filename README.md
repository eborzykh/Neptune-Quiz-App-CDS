# Neptune-Quiz-App-CDS
This is an optional part and data visualisation layer created for [Neptune-Quiz-App]( https://github.com/eborzykh/Neptune-Quiz-App) to test some of ABAP CDS View features (like dynamic layout, custom actions, calculated fields).
ABAP CDS views created in this repository will be used in [Neptune-Quiz-App-Fiori]( https://github.com/eborzykh/Neptune-Quiz-App-Fiori) to automatically generate UI application with SAP Fiori Elements.

### Naming convention used for ABAP CDS View

| Component | Type | Name |
| ---- | ---- | ---- |
| Data definition | Basic| Z [unit] _ [app] _ I _* |
| Data definition | Composite | Z [unit] _ [app] _ I _* |
| Data definition | Consumption | Z [unit] _ [app] _ C _* |
| Metadata extensions | Extension | Z [unit] _ [app] _ E _* |
| Class | Behavior Implementation Class | ZBP_ [unit] _ [app] _* |
| Class | Message Class | Z [unit] _ [app] _ CM _* |
| Service definition | UI | Z [unit] _ [app] _ UI _* |
| Service definition | API | Z [unit] _ [app] _ API _* |
| Service Binding | OData V2 – UI | Z [unit] _ [app] _ UI _*_02 |
| Service Binding | OData V2 – Web API | Z [unit] _ [app] _ API _*_02 |
| Service Binding | OData V4 – UI | Z [unit] _ [app] _ UI _*_04 |
| Service Binding | OData V4 – Web API | Z [unit] _ [app] _ API _*_04 |

### Related links:

* Part 1. [Neptune-Quiz-App](https://github.com/eborzykh/Neptune-Quiz-App)
* Part 2. Neptune-Quiz-App-CDS
* Part 3. [Neptune-Quiz-App-Fiori](https://github.com/eborzykh/Neptune-Quiz-App-Fiori)
