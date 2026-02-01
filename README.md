# Neptune-Quiz-App-CDS
This is an optional part and data visualisation layer created for [Neptune-Quiz-App]( https://github.com/eborzykh/Neptune-Quiz-App) to test some of ABAP CDS View features (like dynamic layout, custom actions, calculated fields).
ABAP CDS views created in this repository will be used in [Neptune-Quiz-App-Fiori]( https://github.com/eborzykh/Neptune-Quiz-App-Fiori) to automatically generate UI application with SAP Fiori Elements.

### Naming convention used for ABAP CDS View

| Component | Type | Name (30) | Suffix |
| ---- | ---- | ---- | ---- |
| Data definition | Basic view | Z [unit] _ [app] _ I _* | _VH - Value Help |
| Data definition | Basic Interface view | Z [unit] _ [app] _ I _* |  |
| Data definition | Basic restricted view | Z [unit] _ [app] _ R _* |  |
| Data definition | Abstract entity view | Z [unit] _ [app] _ A _* |  |
| Data definition | Draft Query View | Z [unit] _ [app] _ D _* |  |
| Data definition | Consumption view | Z [unit] _ [app] _ C _* |  |
| Data definition | Projection view | Z [unit] _ [app] _ C _* |  |
| Data definition | Private view | Z [unit] _ [app] _ P _* |  |
| Data definition | Remote API view | Z [unit] _ [app] _ A _* |  |
| Data definition | View extend | Z [unit] _ [app] _ X _* |  |
| Data definition | Derivation function | Z [unit] _ [app] _ F _* |  |
| Data definition | Abstract entity | Z [unit] _ [app] _ D _* |  |
| Metadata extensions | Extension include view | Z [unit] _ [app] _ E _* |  |
| Class | Behavior Implementation Class | ZBP_ [unit] _ [app] _* |  |
| Class | Message Class | Z [unit] _ [app] _ CM _* |  |
| Service definition | UI | Z [unit] _ [app] _ UI _* |  |
| Service definition | API | Z [unit] _ [app] _ API _* |  |
| Service Binding | OData – UI V2 / V4 | Z [unit] _ [app] _ UI _* | _O2 / _O4 |
| Service Binding | OData – Web API V2 / V4 | Z [unit] _ [app] _ API _* | _O2 / _O4 |
| Scenario | Read Only | Z [unit] _ [app] _ [object] | _R |
| Scenario | Managed | Z [unit] _ [app] _ [object] | _M |
| Scenario | Unmanaged | Z [unit] _ [app] _ [object] | _U |
| Scenario | Cockpit | Z [unit] _ [app] _ [object] | _C |

### Related links:

* Part 1. [Neptune-Quiz-App](https://github.com/eborzykh/Neptune-Quiz-App)
* Part 2. Neptune-Quiz-App-CDS
* Part 3. [Neptune-Quiz-App-Fiori](https://github.com/eborzykh/Neptune-Quiz-App-Fiori)
