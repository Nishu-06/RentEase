package com.rentease.service;

import com.rentease.dto.TenantDto;
import com.rentease.entity.Property;
import com.rentease.entity.Tenant;
import com.rentease.exception.ResourceNotFoundException;
import com.rentease.repository.PropertyRepository;
import com.rentease.repository.TenantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class TenantService {
    
    @Autowired
    private TenantRepository tenantRepository;
    
    @Autowired
    private PropertyRepository propertyRepository;
    
    public TenantDto createTenant(TenantDto tenantDto) {
        Property property = propertyRepository.findById(tenantDto.getPropertyId())
                .orElseThrow(() -> new ResourceNotFoundException("Property not found with id: " + tenantDto.getPropertyId()));
        
        Tenant tenant = new Tenant();
        tenant.setName(tenantDto.getName());
        tenant.setEmail(tenantDto.getEmail());
        tenant.setPhone(tenantDto.getPhone());
        tenant.setProperty(property);
        
        Tenant savedTenant = tenantRepository.save(tenant);
        return convertToDto(savedTenant);
    }
    
    public List<TenantDto> getAllTenants() {
        return tenantRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<TenantDto> getTenantsByProperty(Long propertyId) {
        return tenantRepository.findByPropertyId(propertyId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public TenantDto getTenantById(Long id) {
        Tenant tenant = tenantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Tenant not found with id: " + id));
        return convertToDto(tenant);
    }
    
    public TenantDto updateTenant(Long id, TenantDto tenantDto) {
        Tenant tenant = tenantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Tenant not found with id: " + id));
        
        Property property = propertyRepository.findById(tenantDto.getPropertyId())
                .orElseThrow(() -> new ResourceNotFoundException("Property not found with id: " + tenantDto.getPropertyId()));
        
        tenant.setName(tenantDto.getName());
        tenant.setEmail(tenantDto.getEmail());
        tenant.setPhone(tenantDto.getPhone());
        tenant.setProperty(property);
        
        Tenant updatedTenant = tenantRepository.save(tenant);
        return convertToDto(updatedTenant);
    }
    
    public void deleteTenant(Long id) {
        if (!tenantRepository.existsById(id)) {
            throw new ResourceNotFoundException("Tenant not found with id: " + id);
        }
        tenantRepository.deleteById(id);
    }
    
    private TenantDto convertToDto(Tenant tenant) {
        TenantDto dto = new TenantDto();
        dto.setId(tenant.getId());
        dto.setName(tenant.getName());
        dto.setEmail(tenant.getEmail());
        dto.setPhone(tenant.getPhone());
        dto.setPropertyId(tenant.getProperty().getId());
        dto.setPropertyTitle(tenant.getProperty().getTitle());
        return dto;
    }
}
