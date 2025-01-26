# Neptune-Quiz-App-CDS
This is an optional part and data visualisation layer created for [Neptune-Quiz-App]( https://github.com/eborzykh/Neptune-Quiz-App) to test some of ABAP CDS View features (like dynamic layout, custom actions, calculated fields).
ABAP CDS views created in this repository will be used in [Neptune-Quiz-App-Fiori]( https://github.com/eborzykh/Neptune-Quiz-App-Fiori) to automatically generate UI application with SAP Fiori Elements.

### Naming convention used for ABAP CDS View

| Component | Type | Name |
| ---- | ---- | ---- |
| Data definition | Basic interface view | Z [unit] _ [app] _ I _* | 30 |
| Data definition | Composite interface view | Z [unit] _ [app] _ I _* | 30 |
| Data definition | Value Help view | Z [unit] _ [app] _ I _*_VH | 30 |
| Data definition | Basic restricted reuse view | Z [unit] _ [app] _ R _* | 30 |
| Data definition | Composite restricted reuse view | Z [unit] _ [app] _ R _* | 30 |
| Data definition | Consumption view | Z [unit] _ [app] _ C _* | 30 |
| Data definition | Projection view | Z [unit] _ [app] _ C _* | 30 |
| Data definition | Private view | Z [unit] _ [app] _ P _* | 30 |
| Data definition | Remote API view | Z [unit] _ [app] _ A _* | 30 |
| Data definition | View extend | Z [unit] _ [app] _ X _* | 30 |
| Data definition | Derivation function | Z [unit] _ [app] _ F _* | 30 |
| Data definition | Abstract entity | Z [unit] _ [app] _ D _* | 30 |
| Metadata extensions | Extension include view | Z [unit] _ [app] _ E _* | 30 |
| Class | Behavior Implementation Class | ZBP_ [unit] _ [app] _* | - |
| Class | Message Class | Z [unit] _ [app] _ CM _* | - |
| Service definition | UI | Z [unit] _ [app] _ UI _* | - |
| Service definition | API | Z [unit] _ [app] _ API _* | - |
| Service Binding | OData V2 – UI | Z [unit] _ [app] _ UI _*_O2 | - |
| Service Binding | OData V2 – Web API | Z [unit] _ [app] _ API _*_O2 | - |
| Service Binding | OData V4 – UI | Z [unit] _ [app] _ UI _*_O4 | - |
| Service Binding | OData V4 – Web API | Z [unit] _ [app] _ API _*_O4 | - |

### Related links:

* Part 1. [Neptune-Quiz-App](https://github.com/eborzykh/Neptune-Quiz-App)
* Part 2. Neptune-Quiz-App-CDS
* Part 3. [Neptune-Quiz-App-Fiori](https://github.com/eborzykh/Neptune-Quiz-App-Fiori)
