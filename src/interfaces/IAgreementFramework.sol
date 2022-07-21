// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;
import { AgreementParams, PositionParams, PositionStatus } from "../lib/AgreementStructs.sol";
import { CriteriaResolver } from "../lib/CriteriaResolution.sol";
import { IArbitrable } from "./IArbitrable.sol";

/// @notice Interface for agreements frameworks.
/// @dev Implementations must write the logic to manage individual agreements.
interface IAgreementFramework is IArbitrable {
    /* ====================================================================== //
                                        EVENTS
    // ====================================================================== */

    /// @dev Raised when a new agreement is created.
    /// @param id Id of the new created agreement.
    /// @param termsHash Hash of the detailed terms of the agreement.
    /// @param criteria Criteria requirements to join the agreement.
    event AgreementCreated(uint256 id, bytes32 termsHash, uint256 criteria);

    /// @dev Raised when a new party joins an agreement.
    /// @param id Id of the agreement joined.
    /// @param party Address of party joined.
    /// @param balance Balance of the party joined.
    event AgreementJoined(uint256 id, address party, uint256 balance);

    /// @dev Raised when an existent party of an agreement updates its position.
    /// @param id Id of the agreement updated.
    /// @param party Address of the party updated.
    /// @param balance New balance of the party.
    /// @param status New status of the position.
    event AgreementPositionUpdated(
        uint256 id,
        address party,
        uint256 balance,
        PositionStatus status
    );

    /// @dev Raised when an agreement is finalized.
    /// @param id Id of the agreement finalized.
    event AgreementFinalized(uint256 id);

    /// @dev Raised when an agreement is in dispute.
    /// @param id Id of the agreement in dispute.
    /// @param party Address of the party that raises the dispute.
    event AgreementDisputed(uint256 id, address party);

    /* ====================================================================== //
                                        ERRORS
    // ====================================================================== */

    error NonExistentAgreement();
    error InsufficientBalance();
    error NoPartOfAgreement();
    error PartyAlreadyJoined();
    error PartyAlreadyFinalized();
    error PartyMustMatchCriteria();
    error AgreementAlreadyDisputed();
    error AgreementNotFinalized();
    error AgreementNotDisputed();

    /* ====================================================================== //
                                        VIEWS
    // ====================================================================== */

    /// @notice Retrieve general parameters of an agreement.
    /// @param id Id of the agreement to return data from.
    /// @return AgreementParams struct with the parameters of the agreement.
    function agreementParams(uint256 id) external view returns (AgreementParams memory);

    /// @notice Retrieve positions of an agreement.
    /// @param id Id of the agreement to return data from.
    /// @return Array of PositionParams with all the positions of the agreement.
    function agreementPositions(uint256 id) external view returns (PositionParams[] memory);

    /* ====================================================================== //
                                    USER ACTIONS
    // ====================================================================== */

    /// @notice Create a new agreement with given params.
    /// @param params Struct of agreement params.
    /// @return id Id of the agreement created.
    function createAgreement(AgreementParams calldata params) external returns (uint256 id);

    /// @notice Join an existent agreement.
    /// @dev Requires a deposit over agreement criteria.
    /// @param id Id of the agreement to join.
    /// @param criteriaResolver Criteria data to proof sender can join agreement.
    function joinAgreement(uint256 id, CriteriaResolver calldata criteriaResolver) external;

    /// @notice Signal the will of the caller to finalize an agreement.
    /// @param id Id of the agreement to settle.
    function finalizeAgreement(uint256 id) external;

    /// @notice Dispute agreement so arbitration is needed for finalization.
    /// @param id Id of the agreement to dispute.
    function disputeAgreement(uint256 id) external;

    /// @notice Withdraw your position from the agreement.
    /// @param id Id of the agreement to withdraw from.
    function withdrawFromAgreement(uint256 id) external;
}
