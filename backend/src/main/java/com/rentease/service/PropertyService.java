package com.rentease.service;

import com.rentease.dto.PropertyDto;
import com.rentease.entity.Property;
import com.rentease.entity.User;
import com.rentease.exception.ResourceNotFoundException;
import com.rentease.repository.PropertyRepository;
import com.rentease.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class PropertyService {
    
    @Autowired
    private PropertyRepository propertyRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public PropertyDto createProperty(PropertyDto propertyDto, Long ownerId) {
        User owner = userRepository.findById(ownerId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + ownerId));
        
        Property property = new Property();
        property.setTitle(propertyDto.getTitle());
        property.setAddress(propertyDto.getAddress());
        property.setRentAmount(propertyDto.getRentAmount());
        property.setOwner(owner);
        
        Property savedProperty = propertyRepository.save(property);
        return convertToDto(savedProperty);
    }
    
    public List<PropertyDto> getAllProperties() {
        return propertyRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyDto> getPropertiesByOwner(Long ownerId) {
        return propertyRepository.findByOwnerId(ownerId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public PropertyDto getPropertyById(Long id) {
        Property property = propertyRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Property not found with id: " + id));
        return convertToDto(property);
    }
    
    public PropertyDto updateProperty(Long id, PropertyDto propertyDto) {
        Property property = propertyRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Property not found with id: " + id));
        
        property.setTitle(propertyDto.getTitle());
        property.setAddress(propertyDto.getAddress());
        property.setRentAmount(propertyDto.getRentAmount());
        
        Property updatedProperty = propertyRepository.save(property);
        return convertToDto(updatedProperty);
    }
    
    public void deleteProperty(Long id) {
        if (!propertyRepository.existsById(id)) {
            throw new ResourceNotFoundException("Property not found with id: " + id);
        }
        propertyRepository.deleteById(id);
    }
    
    private PropertyDto convertToDto(Property property) {
        PropertyDto dto = new PropertyDto();
        dto.setId(property.getId());
        dto.setTitle(property.getTitle());
        dto.setAddress(property.getAddress());
        dto.setRentAmount(property.getRentAmount());
        dto.setOwnerId(property.getOwner().getId());
        dto.setOwnerName(property.getOwner().getName());
        return dto;
    }
}
