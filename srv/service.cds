using { BusinessPartnerA2X } from './external/BusinessPartnerA2X.cds';

using { RiskManagement as my } from '../db/schema.cds';

@path : '/service/RiskManagementService'
service RiskManagementService
{
    @cds.redirection.target
    @odata.draft.enabled
    entity Risks as
        projection on my.Risks
        {
            *,
            miti as miti
        }
        excluding
        {
            mitigation
        };

    @cds.redirection.target
    @odata.draft.enabled
    entity Mitigations as
        projection on my.Mitigations;

    @cds.redirection.target
    entity A_BusinessPartner as
        projection on BusinessPartnerA2X.A_BusinessPartner
        {
            BusinessPartner,
            Customer,
            Supplier,
            BusinessPartnerCategory,
            BusinessPartnerFullName,
            BusinessPartnerIsBlocked
        };
}

// annotate RiskManagementService with @requires :
// [
//     'authenticated-user'
// ];

// ------------------------------------------------------
// User Roles & Authorizations
// ------------------------------------------------------

// 定义整个服务需要认证用户才能访问
annotate RiskManagementService with @(requires: 'authenticated-user');

// 为 Risks 实体分配角色权限
annotate RiskManagementService.Risks with @(restrict: [
    {
        grant: ['READ'],
        to: ['RiskViewer']
    },
    {
        grant: ['*'], // 允许所有操作 (CRUD)
        to: ['RiskManager']
    }
]);

// 为 Mitigations 实体分配角色权限
annotate RiskManagementService.Mitigations with @(restrict: [
    {
        grant: ['READ'],
        to: ['RiskViewer']
    },
    {
        grant: ['*'], // 允许所有操作 (CRUD)
        to: ['RiskManager']
    }
]);
