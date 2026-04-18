# Neptune-Quiz-App-CDS

This is a data visualisation and maintenance layer for [Neptune-Quiz-App]( https://github.com/eborzykh/Neptune-Quiz-App) (which is not mandatory for this repository) created to test and demo ABAP CDS implementations. 

## Dependencies 

Dictionary Objects and Data Provider methods required from [Neptune-Quiz-App-DB](https://github.com/eborzykh/Neptune-Quiz-App-DB)

### Naming convention used in this ABAP CDS implementations

| Component | Type | Name (30) | Suffix |
| ---- | ---- | ---- | ---- |
| Data definition | Basic view | Z [unit] _ [app] _ I _* | _VH - Value Help |
| Data definition | Basic Interface view | Z [unit] _ [app] _ I _* |  |
| Data definition | Basic restricted view | Z [unit] _ [app] _ R _* |  |
| Data definition | Abstract entity view | Z [unit] _ [app] _ A _* |  |
| Data definition | Abstract entity view (by SAP) | Z [unit] _ [app] _ D _* |  |
| Data definition | Draft Query View | Z [unit] _ [app] _ D _* |  |
| Data definition | Consumption view | Z [unit] _ [app] _ C _* |  |
| Data definition | Projection view | Z [unit] _ [app] _ C _* |  |
| Data definition | Composite restricted view (by SAP) | Z [unit] _ [app] _ R _* |  |
| Data definition | Private view | Z [unit] _ [app] _ P _* |  |
| Data definition | Remote API view | Z [unit] _ [app] _ A _* |  |
| Data definition | View extend | Z [unit] _ [app] _ X _* |  |
| Data definition | Derivation function | Z [unit] _ [app] _ F _* |  |
| Metadata extensions | Extension include view | Z [unit] _ [app] _ E _* |  |
| Class | Behavior Implementation Class | ZBP_ [unit] _ [app] _* |  |
| Class | Message Class | Z [unit] _ [app] _ CM _* |  |
| Service definition | UI | Z [unit] _ [app] _ UI _* |  |
| Service definition | API | Z [unit] _ [app] _ API _* |  |
| Service Binding | OData – UI V2 / V4 | Z [unit] _ [app] _ UI _* | _O2 / _O4 |
| Service Binding | OData – Web API V2 / V4 | Z [unit] _ [app] _ API _* | _O2 / _O4 |
| Scenario | Read Only | Z [unit] _ [app] _ [object] | _R |
| Scenario | Managed | Z [unit] _ [app] _ [object] | _M |
| Scenario | Draft | Z [unit] _ [app] _ [object] | _D |
| Scenario | Unmanaged | Z [unit] _ [app] _ [object] | _U |

> [!NOTE]
> It is good to align naming convention for each project to have the most native object names. 
> For example, if we do not have API views but will be creating abstracts then use `A_` for abstract views instead of `D_` (which might be used for Draft views instead).

